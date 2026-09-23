#!/usr/bin/env bash

set -Eeuo pipefail

APP_NAMESPACE="${APP_NAMESPACE:-devsecops}"
MONITORING_NAMESPACE="${MONITORING_NAMESPACE:-monitoring}"

echo "=============================================="
echo " DevSecOps Platform - Verification"
echo "=============================================="

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
echo "Application Namespace"
echo "----------------------------------------------"

if kubectl get namespace "${APP_NAMESPACE}" >/dev/null 2>&1; then
    echo "PASS: ${APP_NAMESPACE}"
else
    echo "ERROR: Namespace '${APP_NAMESPACE}' does not exist."
    exit 1
fi

echo
echo "Application resources:"
kubectl get all -n "${APP_NAMESPACE}"

echo
echo "----------------------------------------------"
echo "Monitoring Namespace"
echo "----------------------------------------------"

if kubectl get namespace "${MONITORING_NAMESPACE}" >/dev/null 2>&1; then
    echo "PASS: ${MONITORING_NAMESPACE}"
else
    echo "ERROR: Namespace '${MONITORING_NAMESPACE}' does not exist."
    exit 1
fi

echo
echo "Monitoring resources:"
kubectl get all -n "${MONITORING_NAMESPACE}"

echo
echo "----------------------------------------------"
echo "Persistent Volume Claims"
echo "----------------------------------------------"

kubectl get pvc -n "${APP_NAMESPACE}" 2>/dev/null || true
kubectl get pvc -n "${MONITORING_NAMESPACE}" 2>/dev/null || true

echo
echo "----------------------------------------------"
echo "Pod Status"
echo "----------------------------------------------"

echo
echo "Application pods:"
kubectl get pods -n "${APP_NAMESPACE}"

echo
echo "Monitoring pods:"
kubectl get pods -n "${MONITORING_NAMESPACE}"

echo
echo "=============================================="
echo " Verification Completed"
echo "=============================================="