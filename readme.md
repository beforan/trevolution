playing around with TREvolution install

---------------------------------------

Install MicroK8S

cat 1-install.sh | sh

Install ArgoCD

cat 2-argocd.sh | sh

Show argoCD login if needed

cat show-argocd.sh | sh

---------------------------------------

Install LENS (UI for Kuberneties)

cat 3-lens.sh | sh

---------------------------------------

Trigger ArgoCD 

cat 4-watcher.sh | sh



# Flexible notes around reuse outside of Ubuntu script install above

## Break down of the steps in `1-install.sh`

Installs microk8s. If you want to use a different distro you don't need this script, but some of the steps may be of interest for configuring your alternative distro.

This script does a number of things; some of them are host os specific. `main` targets Ubuntu.

1. Install dependencies e.g. curl if necessary
1. Install snapd if necessary
    - enable snaps classic mode
1. Add snaps to PATH

The above are linux specific prereqs for installing microk8s, since it's only distributed by snap for linux.

The below should be broadly applicable to all host environments, but may be done differently on different hosts.

> [!NOTE]
> **Read these steps!** This is the main reusable bit.

1. Install microk8s
    - The scripts do this for linux via snaps, but obvs this step is applicable to any host environment
1. Add user to microk8s group (some environments may need a reboot here)
1. Install microk8s plugins
    - useful in all cases
1. Add kubectl alias
    - host environment specific
    - this should maybe be optional - user could also install kubectl standalone and not need this
1. Configure kubectl with microk8s config
    - useful in all cases

## `2-argocd.sh`

This is all microk8s or kubectl commands, so once you have microk8s it should Just Work.

`2a-argocd.sh` is a microk8s independent version that should work for other suitable distros e.g. Minikube.

There may be some caveats, e.g.

- on Minikube, additional port forwarding may be needed to access argocd in a browser.
    - Using minikube CLI: `minikube service argocd-server -n argocd --url`
    - Using vanilla kubectl: `kubectl -n argocd port-forward svc/argocd-server <ARGOCD_PORT>:80`


## `3-lens.sh`

I think this should be optional (probably not numbered) as I think Lens needs a license.

Consumers may prefer alternatives (see below).

Currently this script in `main` is Debian specific (`apt install`), in `fedora` it's Linux specific using snaps.

Other Host environments may optionally install this their favourite way.

### Alternatives

- Open Lens (on Flathub, probably elsewhere)
- k9s
- kubernetes-dashboard
- ...?

## `4-watcher.sh`

This is all (microk8s) kubectl commands so host non-specific, as with `2-argocd.sh`.

`4a-watcher.sh` is the Vanilla kubectl version.

## `show-argocd.sh`

This is (microk8s) kubectl commands so host non-specific.

`show-argocd-vanilla.sh` is the Vanilla kubectl version.

## `uninstall.sh`

This uses snaps to uninstall microk8s, so is Linux and microk8s specific.

# non microk8s thoughts

The main initial thing for using non microk8s is considering what microk8s features (or in particular addons!) are needed and how to fulfill them on another distro.

## Calico

We expect a k8s distro that supports Calico.

Minikube supports it with `minikube start --cni calico`

https://minikube.sigs.k8s.io/docs/handbook/network_policy/

## CoreDNS

We should be using CoreDNS.

Minikube does by default now.

This could probably be the biggest faff as for some distros if it means understanding deploying CoreDNS on the cluster (rather than the simple microk8s addon).

## Hostpath Storage (for Dev)

Minikube is configured for this by default: https://minikube.sigs.k8s.io/docs/handbook/persistent_volumes/

## Other addons

Dashboard and Helm shouldn't really matter. They are installable independently.

Helm can be installed the users favourite way, just as kubectl can.

Dashboard can be installed independently or may be provided by the user's distro (e.g. Minikube ships with it and can be used by `minikube dashboard`)