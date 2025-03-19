# Get the NodePort
ARGOCD_PORT=$(kubectl get svc argocd-server -n argocd -o=jsonpath='{.spec.ports[0].nodePort}')
echo "✅ ArgoCD is exposed on port: $ARGOCD_PORT"

# Get the ArgoCD admin password
echo "🔑 Retrieving ArgoCD admin password..."
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)
echo "➡️  ArgoCD UI Login:"
echo "   - URL: http://<your-node-ip>:$ARGOCD_PORT"
echo "   - Username: admin"
echo "   - Password: $ARGOCD_PASSWORD"