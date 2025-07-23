# Kubernetes Development Environment

This folder contains all Kubernetes-related configurations, Helm charts, and deployment scripts for local development.

## 📁 Structure

```
k8s/
├── argo/                    # ArgoCD configurations and scripts
│   ├── deploy-argocd.sh    # ArgoCD deployment script
│   ├── cleanup-argocd.sh   # ArgoCD cleanup script
│   ├── values-custom.yaml  # Custom ArgoCD values
│   └── README.md           # ArgoCD documentation
├── helm/                    # Local Helm charts
│   ├── argo-cd/            # ArgoCD Helm chart (local copy)
│   └── README.md           # Helm documentation
├── kind-setup.md           # Kind cluster setup guide
├── .gitignore              # Git ignore rules for k8s
└── README.md               # This file
```

## 🚀 Quick Start

### Prerequisites

- **Docker Desktop** - Running and configured
- **Kind** - `brew install kind`
- **kubectl** - Kubernetes command-line tool
- **Helm** - `brew install helm`

### 1. Create a Kind Cluster

```bash
kind create cluster --name my-cluster
```

### 2. Deploy ArgoCD (Optional)

```bash
cd argo
./deploy-argocd.sh my-cluster
```

### 3. Access ArgoCD UI

```bash
kubectl port-forward service/argo-argocd-server -n argocd 8080:443
```

Then visit: https://localhost:8080

## 🛠️ Available Tools

### Kind Cluster Management
- **Create cluster**: `kind create cluster --name my-cluster`
- **List clusters**: `kind get clusters`
- **Delete cluster**: `kind delete cluster --name my-cluster`

### ArgoCD Management
- **Deploy**: `./argo/deploy-argocd.sh my-cluster`
- **Cleanup**: `./argo/cleanup-argocd.sh my-cluster`
- **Get password**: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

### Helm Chart Management
- **Install from local**: `helm install my-release ./helm/argo-cd`
- **Update charts**: `helm repo update`
- **List releases**: `helm list`

## 📚 Documentation

- [Kind Setup Guide](kind-setup.md) - Complete Kind cluster setup and usage
- [ArgoCD Guide](argo/README.md) - ArgoCD deployment and configuration
- [Helm Charts Guide](helm/README.md) - Local Helm chart management

## 🔧 Useful Commands

### Cluster Status
```bash
# Check cluster info
kubectl cluster-info

# List nodes
kubectl get nodes

# Get all resources
kubectl get all --all-namespaces
```

### ArgoCD Commands
```bash
# Port forward to ArgoCD UI
kubectl port-forward service/argo-argocd-server -n argocd 8080:443

# Get ArgoCD admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# List ArgoCD applications
kubectl get applications -n argocd
```

### Helm Commands
```bash
# Install ArgoCD using local chart
helm install argo ./helm/argo-cd --namespace argocd --create-namespace

# Uninstall ArgoCD
helm uninstall argo -n argocd

# List Helm releases
helm list --all-namespaces
```

## 🧹 Cleanup

To completely clean up your environment:

```bash
# Clean up ArgoCD
cd argo
./cleanup-argocd.sh my-cluster

# Delete Kind cluster
kind delete cluster --name my-cluster
```

## 📝 Notes

- All sensitive files (keys, certificates, secrets) are ignored by `.gitignore`
- Local Helm charts are stored in `helm/` for offline use
- Custom configurations are in `argo/values-custom.yaml`
- Scripts are provided for easy deployment and cleanup

---

**Last Updated**: January 2025 # Updated Git configuration
