#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROLLBACK_SCRIPT="${PROJECT_ROOT}/deployment/scripts/rollback.sh"

echo "=============================================="
echo " DevSecOps Platform - Rollback"
echo "=============================================="

if ! command -v kubectl >/dev/null 2>&1; then
    echo "ERROR: kubectl is not installed."
    exit 1
fi

if ! kubectl cluster-info >/dev/null 2>&1; then
    echo "ERROR: Kubernetes cluster is not reachable."
    exit 1
fi

if [ ! -f "${ROLLBACK_SCRIPT}" ]; then
    echo "ERROR: Rollback script not found:"
    echo "${ROLLBACK_SCRIPT}"
    exit 1
fi

if [ ! -x "${ROLLBACK_SCRIPT}" ]; then
    echo "Making rollback script executable..."
    chmod +x "${ROLLBACK_SCRIPT}"
fi

echo
echo "Starting rollback..."

"${ROLLBACK_SCRIPT}"

echo
echo "=============================================="
echo " Rollback Completed"
echo "=============================================="