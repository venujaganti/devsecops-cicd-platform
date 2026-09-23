#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEPLOY_SCRIPT="${PROJECT_ROOT}/deployment/scripts/deploy.sh"

echo "=============================================="
echo " DevSecOps Platform - Deploy"
echo "=============================================="

if ! command -v kubectl >/dev/null 2>&1; then
    echo "ERROR: kubectl is not installed."
    exit 1
fi

if [ ! -f "${DEPLOY_SCRIPT}" ]; then
    echo "ERROR: Deployment script not found:"
    echo "${DEPLOY_SCRIPT}"
    exit 1
fi

if [ ! -x "${DEPLOY_SCRIPT}" ]; then
    echo "Making deployment script executable..."
    chmod +x "${DEPLOY_SCRIPT}"
fi

echo
echo "Starting deployment..."

"${DEPLOY_SCRIPT}"

echo
echo "=============================================="
echo " Deployment Completed"
echo "=============================================="