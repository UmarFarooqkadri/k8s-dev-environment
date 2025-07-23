#!/bin/bash

# ArgoCD Cleanup Script
# This script removes ArgoCD from the cluster

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

echo -e "${YELLOW}🧹 Starting ArgoCD cleanup...${NC}"

# Check if Kind cluster exists
if ! kind get clusters | grep -q "$CLUSTER_NAME"; then
    echo -e "${RED}❌ Kind cluster '$CLUSTER_NAME' not found!${NC}"
    exit 1
fi

# Stop any running port-forward processes
echo -e "${GREEN}🛑 Stopping port-forward processes...${NC}"
pkill -f "kubectl port-forward.*argocd" || true

# Uninstall ArgoCD Helm release
if helm list -n "$NAMESPACE" | grep -q "$RELEASE_NAME"; then
    echo -e "${GREEN}🗑️  Uninstalling ArgoCD Helm release...${NC}"
    helm uninstall "$RELEASE_NAME" -n "$NAMESPACE"
else
    echo -e "${YELLOW}⚠️  ArgoCD Helm release not found${NC}"
fi

# Delete namespace
if kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
    echo -e "${GREEN}🗑️  Deleting namespace: $NAMESPACE${NC}"
    kubectl delete namespace "$NAMESPACE"
else
    echo -e "${YELLOW}⚠️  Namespace '$NAMESPACE' not found${NC}"
fi

echo -e "${GREEN}✅ ArgoCD cleanup completed!${NC}"
echo -e "${YELLOW}💡 Note: CustomResourceDefinitions may remain (this is normal)${NC}" 