# Helm Charts

This folder contains locally downloaded Helm charts for offline use and customization.

## 📁 Current Charts

### ArgoCD Chart
- **Location**: `argo-cd/`
- **Version**: 8.2.0
- **App Version**: v3.0.11
- **Source**: [ArgoCD Helm Chart](https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd)

## 📥 Downloading Charts

### ArgoCD Chart
```bash
# Download the latest version
helm pull argo/argo-cd --untar

# Download a specific version
helm pull argo/argo-cd --untar --version 8.2.0
```

### Other Charts
```bash
# Example: Download other charts
helm pull bitnami/nginx --untar
helm pull prometheus-community/kube-prometheus-stack --untar
```

## 🔧 Using Local Charts

### Install from Local Chart
```bash
# Basic installation
helm install my-release ./argo-cd

# With custom values
helm install my-release ./argo-cd --values custom-values.yaml

# In specific namespace
helm install my-release ./argo-cd --namespace my-namespace --create-namespace
```

### Upgrade from Local Chart
```bash
helm upgrade my-release ./argo-cd --values custom-values.yaml
```

### Template Generation
```bash
# Generate templates without installing
helm template my-release ./argo-cd --values custom-values.yaml

# Output to file
helm template my-release ./argo-cd --values custom-values.yaml > rendered-manifests.yaml
```

## 📋 Chart Structure

Each chart contains:
```
chart-name/
├── Chart.yaml          # Chart metadata
├── values.yaml         # Default values
├── templates/          # Kubernetes manifests
├── charts/             # Dependencies (if any)
└── README.md           # Chart documentation
```

## 🔄 Updating Charts

To update a chart to the latest version:

```bash
# Remove old version
rm -rf argo-cd/

# Download new version
helm pull argo/argo-cd --untar

# Check version
cat argo-cd/Chart.yaml | grep version
```

## 📚 Resources

- [Helm Documentation](https://helm.sh/docs/)
- [ArgoCD Helm Chart](https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd)
- [Helm Chart Best Practices](https://helm.sh/docs/chart_best_practices/) 