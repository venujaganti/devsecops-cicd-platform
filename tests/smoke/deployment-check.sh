#!/usr/bin/env bash

set -Eeuo pipefail

echo "========================================"
echo " Kubernetes Deployment Smoke Test"
echo "========================================"

if ! command -v kubectl >/dev/null 2>&1; then
    echo "ERROR: kubectl is not installed."
    exit 1
fi

if ! kubectl cluster-info >/dev/null 2>&1; then
    echo "ERROR: Kubernetes cluster is not reachable."
    exit 1
fi

APP_NAMESPACE="${APP_NAMESPACE:-devsecops}"
MONITORING_NAMESPACE="${MONITORING_NAMESPACE:-monitoring}"

FAILED=0

check_deployment() {
    local namespace="$1"
    local deployment="$2"

    echo
    echo "Checking ${namespace}/${deployment}"

    if ! kubectl get deployment "${deployment}" \
        -n "${namespace}" >/dev/null 2>&1; then

        echo "SKIP: Deployment '${deployment}' does not exist."
        return 0
    fi

    READY="$(kubectl get deployment "${deployment}" \
        -n "${namespace}" \
        -o jsonpath='{.status.readyReplicas}')"

    DESIRED="$(kubectl get deployment "${deployment}" \
        -n "${namespace}" \
        -o jsonpath='{.spec.replicas}')"

    READY="${READY:-0}"
    DESIRED="${DESIRED:-0}"

    echo "Ready replicas: ${READY}"
    echo "Desired replicas: ${DESIRED}"

    if [ "${READY}" -ne "${DESIRED}" ]; then
        echo "FAIL: Deployment is not fully ready."
        FAILED=1
    else
        echo "PASS: Deployment is ready."
    fi
}

check_deployment "${APP_NAMESPACE}" "backend"
check_deployment "${APP_NAMESPACE}" "frontend"
check_deployment "${APP_NAMESPACE}" "postgres"

check_deployment "${MONITORING_NAMESPACE}" "prometheus"
check_deployment "${MONITORING_NAMESPACE}" "grafana"
check_deployment "${MONITORING_NAMESPACE}" "alertmanager"

echo

if [ "${FAILED}" -ne 0 ]; then
    echo "Deployment smoke test FAILED."
    exit 1
fi

echo "Deployment smoke test PASSED."