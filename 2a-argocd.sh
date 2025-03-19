#!/bin/bash

set -e  # Exit on error

echo "🚀 Installing ArgoCD on current k8s cluster..."

# Create the ArgoCD namespace
kubectl create namespace argocd || echo "Namespace 'argocd' already exists"

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
echo "⏳ Waiting for ArgoCD components to be ready..."
kubectl wait --for=condition=available --timeout=600s -n argocd deployment/argocd-server

# Expose ArgoCD server using NodePort
echo "🔧 Exposing ArgoCD via NodePort..."
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

# Get the NodePort
ARGOCD_PORT=$(kubectl get svc argocd-server -n argocd -o=jsonpath='{.spec.ports[0].nodePort}')
echo "✅ ArgoCD is exposed on port: $ARGOCD_PORT"
# TODO: This is all well and good but on Minikube further port fowarding is needed
# Should we echo some advice?
# e.g. $ARGOCD_PORT = 30392
# kubectl -n argocd port-forward svc/argocd-server 30392:80

# Get the ArgoCD admin password
echo "🔑 Retrieving ArgoCD admin password..."
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)
echo "➡️  ArgoCD UI Login:"
echo "   - URL: http://<your-node-ip>:$ARGOCD_PORT"
echo "   - Username: admin"
echo "   - Password: $ARGOCD_PASSWORD"

echo "🎉 ArgoCD installation is complete!"
