# ArgoCD Local Setup

This folder contains everything needed to deploy ArgoCD locally using Kind and Helm.

## 📁 Folder Structure

```
k8s/argo/
├── README.md                 # This file
├── deploy-argocd.sh         # Deployment script
├── cleanup-argocd.sh        # Cleanup script
└── values-custom.yaml       # Custom values for ArgoCD
```

## 🚀 Quick Start

### Prerequisites

1. **Kind cluster** - Create a Kind cluster first:
   ```bash
   kind create cluster --name my-cluster
   ```

2. **Helm chart** - The ArgoCD chart should be downloaded in `../helm/argo-cd/`

### Deploy ArgoCD

Run the deployment script:
```bash
./deploy-argocd.sh [cluster-name]
```

**Example:**
```bash
./deploy-argocd.sh my-cluster
```

### Access ArgoCD

After deployment, you can access ArgoCD in two ways:

#### 1. Web UI
```bash
kubectl port-forward service/argo-argocd-server -n argocd 8080:443
```
Then open: https://localhost:8080

#### 2. CLI
```bash
# Get the admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Login
argocd login localhost:8080 --insecure --username admin --password <password>
```

### Cleanup

To remove ArgoCD:
```bash
./cleanup-argocd.sh [cluster-name]
```

## 📋 Customization

### Values File

The `values-custom.yaml` file contains common customizations:

- **Ingress configuration** - For external access
- **Resource limits** - CPU and memory constraints
- **Security settings** - RBAC, security contexts
- **Metrics** - Prometheus integration
- **High availability** - Multi-replica setup

### Modify Values

Edit `values-custom.yaml` to customize your deployment:

```yaml
# Example: Change resource limits
server:
  resources:
    limits:
      cpu: 1000m
      memory: 1Gi
    requests:
      cpu: 500m
      memory: 512Mi
```

## 🔧 Manual Deployment

If you prefer to deploy manually:

```bash
# Create namespace
kubectl create namespace argocd

# Install with custom values
helm install argo ../helm/argo-cd \
  --namespace argocd \
  --values values-custom.yaml \
  --wait \
  --timeout 10m
```

## 📊 Monitoring

Check deployment status:
```bash
# Pod status
kubectl get pods -n argocd

# Service status
kubectl get svc -n argocd

# Helm release status
helm list -n argocd
```

## 🐛 Troubleshooting

### Common Issues

1. **Port already in use**
   ```bash
   # Stop existing port-forward
   pkill -f "kubectl port-forward"
   ```

2. **Pods not ready**
   ```bash
   # Check pod logs
   kubectl logs -n argocd <pod-name>
   
   # Describe pod
   kubectl describe pod -n argocd <pod-name>
   ```

3. **Helm installation fails**
   ```bash
   # Check Helm status
   helm status argo -n argocd
   
   # Rollback if needed
   helm rollback argo -n argocd
   ```

### Logs

View component logs:
```bash
# Server logs
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server

# Controller logs
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-application-controller

# Repo server logs
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-repo-server
```

## 📚 Resources

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [ArgoCD Helm Chart](https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd)
- [Kind Documentation](https://kind.sigs.k8s.io/docs/)
- [Helm Documentation](https://helm.sh/docs/) 