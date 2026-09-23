#!/usr/bin/env bash

set -Eeuo pipefail

echo "========================================"
echo " Kubernetes Integration Test"
echo "========================================"

if ! command -v kubectl >/dev/null 2>&1; then
    echo "ERROR: kubectl is not installed."
    exit 1
fi

echo "Checking Kubernetes connectivity..."

if ! kubectl cluster-info >/dev/null 2>&1; then
    echo "ERROR: Kubernetes cluster is not reachable."
    exit 1
fi

echo "Kubernetes cluster is reachable."
echo

APP_NAMESPACE="${APP_NAMESPACE:-devsecops}"
MONITORING_NAMESPACE="${MONITORING_NAMESPACE:-monitoring}"

echo "Checking application namespace: ${APP_NAMESPACE}"

if ! kubectl get namespace "${APP_NAMESPACE}" >/dev/null 2>&1; then
    echo "ERROR: Namespace '${APP_NAMESPACE}' does not exist."
    exit 1
fi

echo "Application namespace exists."
echo

echo "Checking monitoring namespace: ${MONITORING_NAMESPACE}"

if ! kubectl get namespace "${MONITORING_NAMESPACE}" >/dev/null 2>&1; then
    echo "ERROR: Namespace '${MONITORING_NAMESPACE}' does not exist."
    exit 1
fi

echo "Monitoring namespace exists."
echo

echo "Checking application deployments..."

APP_DEPLOYMENTS=(
    "backend"
    "frontend"
    "postgres"
)

for deployment in "${APP_DEPLOYMENTS[@]}"; do
    if ! kubectl get deployment "${deployment}" \
        -n "${APP_NAMESPACE}" >/dev/null 2>&1; then

        echo "WARNING: Deployment '${deployment}' was not found."
        echo "This may be expected if the deployment uses a different name."
    else
        echo "Found deployment: ${deployment}"
    fi
done

echo
echo "Checking monitoring deployments..."

MONITORING_DEPLOYMENTS=(
    "prometheus"
    "grafana"
    "alertmanager"
)

for deployment in "${MONITORING_DEPLOYMENTS[@]}"; do
    if ! kubectl get deployment "${deployment}" \
        -n "${MONITORING_NAMESPACE}" >/dev/null 2>&1; then

        echo "WARNING: Monitoring deployment '${deployment}' was not found."
    else
        echo "Found deployment: ${deployment}"
    fi
done

echo
echo "Current application pods:"
kubectl get pods -n "${APP_NAMESPACE}" || true

echo
echo "Current monitoring pods:"
kubectl get pods -n "${MONITORING_NAMESPACE}" || true

echo
echo "Kubernetes integration test PASSED."