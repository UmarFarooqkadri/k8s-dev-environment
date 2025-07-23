# Kubernetes Cluster Setup with Kind

## Cluster Information
- **Cluster Name**: my-cluster
- **Kubernetes Version**: v1.33.1
- **Context**: kind-my-cluster
- **Control Plane**: Running on localhost:62201

## Useful Commands

### Cluster Management
```bash
# List all clusters
kind get clusters

# Get cluster info
kubectl cluster-info --context kind-my-cluster

# Check nodes
kubectl get nodes

# Delete cluster
kind delete cluster --name my-cluster
```

### Working with the Cluster
```bash
# Set context (if needed)
kubectl config use-context kind-my-cluster

# Get all pods in all namespaces
kubectl get pods --all-namespaces

# Get services
kubectl get services --all-namespaces

# Get namespaces
kubectl get namespaces
```

### Deploying Applications
```bash
# Deploy a simple nginx application
kubectl run nginx --image=nginx:latest

# Expose the deployment
kubectl expose deployment nginx --port=80 --type=NodePort

# Get the service URL
kubectl get service nginx
```

## Cluster Configuration
The cluster was created with default settings:
- Single control-plane node
- Calico CNI (Container Network Interface)
- Default storage class
- Docker runtime

## Port Forwarding
To access services running in the cluster from your local machine:
```bash
# Forward a service port to localhost
kubectl port-forward service/nginx 8080:80
```

## ArgoCD Installation (Optional)
To install ArgoCD on your Kind cluster:
```bash
# Add ArgoCD Helm repository
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Install ArgoCD
helm install argo argo/argo-cd --namespace argocd --create-namespace

# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Port forward to access UI
kubectl port-forward service/argo-argocd-server -n argocd 8080:443
```

## Cleanup
When you're done working with the cluster:

### 1. Stop Port Forwarding
```bash
# Stop any running port-forward processes
pkill -f "kubectl port-forward"
```

### 2. Uninstall ArgoCD (if installed)
```bash
# Uninstall ArgoCD
helm uninstall argo -n argocd

# Delete the namespace
kubectl delete namespace argocd
```

### 3. Delete Kind Cluster
```bash
# Delete the entire cluster
kind delete cluster --name my-cluster

# Verify cleanup
kind get clusters
```

### 4. Verify Complete Cleanup
```bash
# Check for any remaining Kind containers
docker ps -a | grep kind

# Should return no results if cleanup was successful
```

## Notes
- The cluster runs inside Docker containers
- All cluster data is ephemeral unless you configure persistent volumes
- The cluster uses the same Docker daemon as your local Docker installation
- ArgoCD CustomResourceDefinitions may remain after uninstall (this is normal) 