#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

KUBERNETES_DIR="${PROJECT_ROOT}/deployment/kubernetes"
MONITORING_DIR="${PROJECT_ROOT}/deployment/monitoring"

APP_NAMESPACE="${APP_NAMESPACE:-devsecops}"
MONITORING_NAMESPACE="${MONITORING_NAMESPACE:-monitoring}"

echo "=============================================="
echo " DevSecOps Platform - Cleanup"
echo "=============================================="
echo
echo "WARNING:"
echo "This will remove Kubernetes application and"
echo "monitoring resources."
echo
echo "Application namespace : ${APP_NAMESPACE}"
echo "Monitoring namespace  : ${MONITORING_NAMESPACE}"
echo

read -r -p "Continue? Type 'yes' to continue: " CONFIRM

if [ "${CONFIRM}" != "yes" ]; then
    echo
    echo "Cleanup cancelled."
    exit 0
fi

if ! command -v kubectl >/dev/null 2>&1; then
    echo "ERROR: kubectl is not installed."
    exit 1
fi

if ! kubectl cluster-info >/dev/null 2>&1; then
    echo "ERROR: Kubernetes cluster is not reachable."
    exit 1
fi

echo
echo "----------------------------------------------"
echo "Removing application resources"
echo "----------------------------------------------"

if [ -d "${KUBERNETES_DIR}" ]; then
    kubectl delete \
        -k "${KUBERNETES_DIR}" \
        --ignore-not-found=true
else
    echo "WARNING: Kubernetes directory not found."
fi

echo
echo "----------------------------------------------"
echo "Removing monitoring resources"
echo "----------------------------------------------"

if [ -f "${MONITORING_DIR}/namespace.yaml" ]; then

    kubectl delete \
        -f "${MONITORING_DIR}/alertmanager/service.yaml" \
        --ignore-not-found=true

    kubectl delete \
        -f "${MONITORING_DIR}/alertmanager/deployment.yaml" \
        --ignore-not-found=true

    kubectl delete \
        -f "${MONITORING_DIR}/alertmanager/configmap.yaml" \
        --ignore-not-found=true

    kubectl delete \
        -f "${MONITORING_DIR}/grafana/service.yaml" \
        --ignore-not-found=true

    kubectl delete \
        -f "${MONITORING_DIR}/grafana/deployment.yaml" \
        --ignore-not-found=true

    kubectl delete \
        -f "${MONITORING_DIR}/grafana/pvc.yaml" \
        --ignore-not-found=true

    kubectl delete \
        -f "${MONITORING_DIR}/grafana/configmap.yaml" \
        --ignore-not-found=true

    kubectl delete \
        -f "${MONITORING_DIR}/prometheus/service.yaml" \
        --ignore-not-found=true

    kubectl delete \
        -f "${MONITORING_DIR}/prometheus/deployment.yaml" \
        --ignore-not-found=true

    kubectl delete \
        -f "${MONITORING_DIR}/prometheus/pvc.yaml" \
        --ignore-not-found=true

    kubectl delete \
        -f "${MONITORING_DIR}/prometheus/configmap.yaml" \
        --ignore-not-found=true

    kubectl delete \
        -f "${MONITORING_DIR}/namespace.yaml" \
        --ignore-not-found=true

else
    echo "WARNING: Monitoring directory not found."
fi

echo
echo "----------------------------------------------"
echo "Removing local Podman images"
echo "----------------------------------------------"

BACKEND_IMAGE="${BACKEND_IMAGE:-devsecops-backend:latest}"
FRONTEND_IMAGE="${FRONTEND_IMAGE:-devsecops-frontend:latest}"

if command -v podman >/dev/null 2>&1; then

    if podman image exists "${BACKEND_IMAGE}"; then
        podman rmi "${BACKEND_IMAGE}"
        echo "Removed ${BACKEND_IMAGE}"
    else
        echo "Backend image not found: ${BACKEND_IMAGE}"
    fi

    if podman image exists "${FRONTEND_IMAGE}"; then
        podman rmi "${FRONTEND_IMAGE}"
        echo "Removed ${FRONTEND_IMAGE}"
    else
        echo "Frontend image not found: ${FRONTEND_IMAGE}"
    fi
else
    echo "Podman not installed; skipping image cleanup."
fi

echo
echo "=============================================="
echo " Cleanup Completed"
echo "=============================================="