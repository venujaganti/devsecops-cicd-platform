#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

KUBERNETES_DIR="${PROJECT_ROOT}/deployment/kubernetes"
MONITORING_DIR="${PROJECT_ROOT}/deployment/monitoring"

APP_NAMESPACE="${APP_NAMESPACE:-devsecops}"
MONITORING_NAMESPACE="${MONITORING_NAMESPACE:-monitoring}"

echo "=============================================="
echo " DevSecOps CI/CD Platform - Deployment"
echo "=============================================="
echo "Project root : ${PROJECT_ROOT}"
echo "App namespace: ${APP_NAMESPACE}"
echo "Monitoring   : ${MONITORING_NAMESPACE}"
echo

if ! command -v kubectl >/dev/null 2>&1; then
    echo "ERROR: kubectl is not installed or not in PATH."
    exit 1
fi

echo "Checking Kubernetes cluster..."

if ! kubectl cluster-info >/dev/null 2>&1; then
    echo "ERROR: Kubernetes cluster is not reachable."
    echo "Start your Kubernetes cluster and try again."
    exit 1
fi

echo "Kubernetes cluster is reachable."
echo

if [ ! -d "${KUBERNETES_DIR}" ]; then
    echo "ERROR: Kubernetes directory not found:"
    echo "${KUBERNETES_DIR}"
    exit 1
fi

if [ ! -d "${MONITORING_DIR}" ]; then
    echo "ERROR: Monitoring directory not found:"
    echo "${MONITORING_DIR}"
    exit 1
fi

echo "----------------------------------------------"
echo "Step 1: Deploy application namespace"
echo "----------------------------------------------"

kubectl apply \
    -f "${KUBERNETES_DIR}/namespace.yaml"

echo

echo "----------------------------------------------"
echo "Step 2: Deploy application resources"
echo "----------------------------------------------"

kubectl apply \
    -k "${KUBERNETES_DIR}"

echo

echo "Application resources applied."
echo

echo "----------------------------------------------"
echo "Step 3: Deploy monitoring namespace"
echo "----------------------------------------------"

kubectl apply \
    -f "${MONITORING_DIR}/namespace.yaml"

echo

echo "----------------------------------------------"
echo "Step 4: Deploy Prometheus"
echo "----------------------------------------------"

kubectl apply \
    -f "${MONITORING_DIR}/prometheus/configmap.yaml"

kubectl apply \
    -f "${MONITORING_DIR}/prometheus/pvc.yaml"

kubectl apply \
    -f "${MONITORING_DIR}/prometheus/deployment.yaml"

kubectl apply \
    -f "${MONITORING_DIR}/prometheus/service.yaml"

echo

echo "----------------------------------------------"
echo "Step 5: Deploy Grafana"
echo "----------------------------------------------"

kubectl apply \
    -f "${MONITORING_DIR}/grafana/configmap.yaml"

kubectl apply \
    -f "${MONITORING_DIR}/grafana/pvc.yaml"

kubectl apply \
    -f "${MONITORING_DIR}/grafana/deployment.yaml"

kubectl apply \
    -f "${MONITORING_DIR}/grafana/service.yaml"

echo

echo "----------------------------------------------"
echo "Step 6: Deploy Alertmanager"
echo "----------------------------------------------"

kubectl apply \
    -f "${MONITORING_DIR}/alertmanager/configmap.yaml"

kubectl apply \
    -f "${MONITORING_DIR}/alertmanager/deployment.yaml"

kubectl apply \
    -f "${MONITORING_DIR}/alertmanager/service.yaml"

echo

echo "=============================================="
echo " Deployment Applied Successfully"
echo "=============================================="

echo
echo "Application resources:"
kubectl get all -n "${APP_NAMESPACE}"

echo
echo "Monitoring resources:"
kubectl get all -n "${MONITORING_NAMESPACE}"

echo
echo "Deployment completed."