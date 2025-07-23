#!/bin/bash

# ArgoCD Deployment Script
# This script deploys ArgoCD using the local Helm chart

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
CLUSTER_NAME=${1:-"my-cluster"}
NAMESPACE="argocd"
RELEASE_NAME="argo"
CHART_PATH="../helm/argo-cd"
VALUES_FILE="values-custom.yaml"

echo -e "${GREEN}🚀 Starting ArgoCD deployment...${NC}"

# Check if Kind cluster exists
if ! kind get clusters | grep -q "$CLUSTER_NAME"; then
    echo -e "${RED}❌ Kind cluster '$CLUSTER_NAME' not found!${NC}"
    echo -e "${YELLOW}💡 Create a cluster first: kind create cluster --name $CLUSTER_NAME${NC}"
    exit 1
fi

# Check if kubectl is configured for the cluster
if ! kubectl cluster-info --context "kind-$CLUSTER_NAME" >/dev/null 2>&1; then
    echo -e "${RED}❌ Cannot connect to cluster '$CLUSTER_NAME'${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Connected to Kind cluster: $CLUSTER_NAME${NC}"

# Check if chart exists
if [ ! -d "$CHART_PATH" ]; then
    echo -e "${RED}❌ ArgoCD chart not found at $CHART_PATH${NC}"
    echo -e "${YELLOW}💡 Download the chart first: helm pull argo/argo-cd --untar${NC}"
    exit 1
fi

# Create namespace if it doesn't exist
if ! kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
    echo -e "${GREEN}📦 Creating namespace: $NAMESPACE${NC}"
    kubectl create namespace "$NAMESPACE"
else
    echo -e "${YELLOW}⚠️  Namespace '$NAMESPACE' already exists${NC}"
fi

# Install ArgoCD using local chart
echo -e "${GREEN}📥 Installing ArgoCD from local chart...${NC}"

if [ -f "$VALUES_FILE" ]; then
    echo -e "${GREEN}📋 Using custom values file: $VALUES_FILE${NC}"
    helm install "$RELEASE_NAME" "$CHART_PATH" \
        --namespace "$NAMESPACE" \
        --values "$VALUES_FILE" \
        --wait \
        --timeout 10m
else
    echo -e "${YELLOW}⚠️  Custom values file not found, using default values${NC}"
    helm install "$RELEASE_NAME" "$CHART_PATH" \
        --namespace "$NAMESPACE" \
        --wait \
        --timeout 10m
fi

# Wait for pods to be ready
echo -e "${GREEN}⏳ Waiting for ArgoCD pods to be ready...${NC}"
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n "$NAMESPACE" --timeout=300s

# Get admin password
echo -e "${GREEN}🔑 Getting admin password...${NC}"
ADMIN_PASSWORD=$(kubectl -n "$NAMESPACE" get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# Display access information
echo -e "${GREEN}✅ ArgoCD deployment completed!${NC}"
echo -e "${GREEN}📋 Access Information:${NC}"
echo -e "  🌐 URL: https://localhost:8080"
echo -e "  👤 Username: admin"
echo -e "  🔐 Password: $ADMIN_PASSWORD"
echo -e ""
echo -e "${YELLOW}💡 To access ArgoCD UI, run:${NC}"
echo -e "  kubectl port-forward service/argo-argocd-server -n $NAMESPACE 8080:443"
echo -e ""
echo -e "${YELLOW}💡 To login via CLI:${NC}"
echo -e "  argocd login localhost:8080 --insecure --username admin --password $ADMIN_PASSWORD"
echo -e ""
echo -e "${YELLOW}💡 To check pod status:${NC}"
echo -e "  kubectl get pods -n $NAMESPACE" 