#!/usr/bin/env bash

set -Eeuo pipefail

APP_NAMESPACE="${APP_NAMESPACE:-devsecops}"
MONITORING_NAMESPACE="${MONITORING_NAMESPACE:-monitoring}"

echo "=============================================="
echo " DevSecOps CI/CD Platform - Rollback"
echo "=============================================="
echo "Application namespace: ${APP_NAMESPACE}"
echo "Monitoring namespace : ${MONITORING_NAMESPACE}"
echo

if ! command -v kubectl >/dev/null 2>&1; then
    echo "ERROR: kubectl is not installed or not in PATH."
    exit 1
fi

if ! kubectl cluster-info >/dev/null 2>&1; then
    echo "ERROR: Kubernetes cluster is not reachable."
    exit 1
fi

rollback_deployment() {
    local namespace="$1"
    local deployment="$2"

    echo
    echo "Checking ${namespace}/${deployment}..."

    if ! kubectl get deployment "${deployment}" \
        -n "${namespace}" >/dev/null 2>&1; then

        echo "SKIP: Deployment '${deployment}' does not exist."
        return 0
    fi

    REVISION="$(kubectl rollout history deployment/"${deployment}" \
        -n "${namespace}" 2>/dev/null | tail -n +3 | wc -l | tr -d ' ')"

    if [ "${REVISION}" -lt 2 ]; then
        echo "SKIP: ${deployment} does not have a previous revision."
        return 0
    fi

    echo "Rolling back ${deployment}..."

    kubectl rollout undo deployment/"${deployment}" \
        -n "${namespace}"

    kubectl rollout status deployment/"${deployment}" \
        -n "${namespace}" \
        --timeout=180s

    echo "Rollback completed for ${deployment}."
}

echo "----------------------------------------------"
echo "Rolling back application deployments"
echo "----------------------------------------------"

rollback_deployment "${APP_NAMESPACE}" "backend"
rollback_deployment "${APP_NAMESPACE}" "frontend"
rollback_deployment "${APP_NAMESPACE}" "postgres"

echo
echo "----------------------------------------------"
echo "Rolling back monitoring deployments"
echo "----------------------------------------------"

rollback_deployment "${MONITORING_NAMESPACE}" "prometheus"
rollback_deployment "${MONITORING_NAMESPACE}" "grafana"
rollback_deployment "${MONITORING_NAMESPACE}" "alertmanager"

echo
echo "=============================================="
echo " Rollback Completed"
echo "=============================================="

echo
echo "Application deployments:"
kubectl get deployments -n "${APP_NAMESPACE}"

echo
echo "Monitoring deployments:"
kubectl get deployments -n "${MONITORING_NAMESPACE}"