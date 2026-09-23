#!/usr/bin/env bash

set -Eeuo pipefail

APP_NAMESPACE="${APP_NAMESPACE:-devsecops}"
MONITORING_NAMESPACE="${MONITORING_NAMESPACE:-monitoring}"

FAILED=0

echo "=============================================="
echo " DevSecOps Platform - Health Check"
echo "=============================================="
echo "Application namespace: ${APP_NAMESPACE}"
echo "Monitoring namespace : ${MONITORING_NAMESPACE}"
echo

if ! command -v kubectl >/dev/null 2>&1; then
    echo "ERROR: kubectl is not installed or not in PATH."
    exit 1
fi

echo "----------------------------------------------"
echo "1. Kubernetes Cluster"
echo "----------------------------------------------"

if kubectl cluster-info >/dev/null 2>&1; then
    echo "PASS: Kubernetes cluster is reachable."
else
    echo "FAIL: Kubernetes cluster is not reachable."
    exit 1
fi

echo
echo "----------------------------------------------"
echo "2. Application Namespace"
echo "----------------------------------------------"

if kubectl get namespace "${APP_NAMESPACE}" >/dev/null 2>&1; then
    echo "PASS: Namespace '${APP_NAMESPACE}' exists."
else
    echo "FAIL: Namespace '${APP_NAMESPACE}' does not exist."
    FAILED=1
fi

echo
echo "----------------------------------------------"
echo "3. Monitoring Namespace"
echo "----------------------------------------------"

if kubectl get namespace "${MONITORING_NAMESPACE}" >/dev/null 2>&1; then
    echo "PASS: Namespace '${MONITORING_NAMESPACE}' exists."
else
    echo "FAIL: Namespace '${MONITORING_NAMESPACE}' does not exist."
    FAILED=1
fi

check_deployments() {
    local namespace="$1"

    echo
    echo "Checking deployments in namespace '${namespace}'..."

    if ! kubectl get deployments -n "${namespace}" >/dev/null 2>&1; then
        echo "WARNING: No deployments found in '${namespace}'."
        return 0
    fi

    while read -r deployment desired ready; do
        [ -z "${deployment}" ] && continue

        echo "Deployment: ${deployment}"
        echo "  Desired: ${desired}"
        echo "  Ready  : ${ready}"

        if [ "${desired}" = "${ready}" ]; then
            echo "  PASS"
        else
            echo "  FAIL"
            FAILED=1
        fi
    done < <(
        kubectl get deployments \
            -n "${namespace}" \
            --no-headers \
            -o custom-columns='NAME:.metadata.name,DESIRED:.spec.replicas,READY:.status.readyReplicas'
    )
}

echo
echo "----------------------------------------------"
echo "4. Application Deployments"
echo "----------------------------------------------"

if kubectl get namespace "${APP_NAMESPACE}" >/dev/null 2>&1; then
    check_deployments "${APP_NAMESPACE}"
fi

echo
echo "----------------------------------------------"
echo "5. Monitoring Deployments"
echo "----------------------------------------------"

if kubectl get namespace "${MONITORING_NAMESPACE}" >/dev/null 2>&1; then
    check_deployments "${MONITORING_NAMESPACE}"
fi

echo
echo "----------------------------------------------"
echo "6. Application Pods"
echo "----------------------------------------------"

if kubectl get namespace "${APP_NAMESPACE}" >/dev/null 2>&1; then
    kubectl get pods -n "${APP_NAMESPACE}"
fi

echo
echo "----------------------------------------------"
echo "7. Monitoring Pods"
echo "----------------------------------------------"

if kubectl get namespace "${MONITORING_NAMESPACE}" >/dev/null 2>&1; then
    kubectl get pods -n "${MONITORING_NAMESPACE}"
fi

echo
echo "----------------------------------------------"
echo "8. Application Services"
echo "----------------------------------------------"

if kubectl get namespace "${APP_NAMESPACE}" >/dev/null 2>&1; then
    kubectl get services -n "${APP_NAMESPACE}"
fi

echo
echo "----------------------------------------------"
echo "9. Monitoring Services"
echo "----------------------------------------------"

if kubectl get namespace "${MONITORING_NAMESPACE}" >/dev/null 2>&1; then
    kubectl get services -n "${MONITORING_NAMESPACE}"
fi

echo

if [ "${FAILED}" -ne 0 ]; then
    echo "=============================================="
    echo " HEALTH CHECK FAILED"
    echo "=============================================="
    exit 1
fi

echo "=============================================="
echo " ALL HEALTH CHECKS PASSED"
echo "=============================================="