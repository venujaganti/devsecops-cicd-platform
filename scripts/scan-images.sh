#!/usr/bin/env bash

set -Eeuo pipefail

BACKEND_IMAGE="${BACKEND_IMAGE:-devsecops-backend:latest}"
FRONTEND_IMAGE="${FRONTEND_IMAGE:-devsecops-frontend:latest}"

TRIVY_IMAGE="${TRIVY_IMAGE:-aquasec/trivy:0.67.2}"

echo "=============================================="
echo " DevSecOps Platform - Image Security Scan"
echo "=============================================="

if ! command -v podman >/dev/null 2>&1; then
    echo "ERROR: Podman is not installed."
    exit 1
fi

echo
echo "Pulling Trivy image..."

podman pull "${TRIVY_IMAGE}"

echo
echo "Checking backend image..."

if ! podman image exists "${BACKEND_IMAGE}"; then
    echo "ERROR: Backend image does not exist:"
    echo "${BACKEND_IMAGE}"
    echo "Run ./scripts/build-images.sh first."
    exit 1
fi

echo
echo "Scanning backend image..."

podman run --rm \
    -v "${HOME}/.cache:/root/.cache" \
    -v "${XDG_RUNTIME_DIR:-/tmp}:/tmp/runtime" \
    "${TRIVY_IMAGE}" \
    image \
    --scanners vuln,secret \
    --severity HIGH,CRITICAL \
    --ignore-unfixed \
    --exit-code 1 \
    "${BACKEND_IMAGE}"

echo
echo "Backend image scan PASSED."

echo
echo "Checking frontend image..."

if ! podman image exists "${FRONTEND_IMAGE}"; then
    echo "ERROR: Frontend image does not exist:"
    echo "${FRONTEND_IMAGE}"
    echo "Run ./scripts/build-images.sh first."
    exit 1
fi

echo
echo "Scanning frontend image..."

podman run --rm \
    -v "${HOME}/.cache:/root/.cache" \
    -v "${XDG_RUNTIME_DIR:-/tmp}:/tmp/runtime" \
    "${TRIVY_IMAGE}" \
    image \
    --scanners vuln,secret \
    --severity HIGH,CRITICAL \
    --ignore-unfixed \
    --exit-code 1 \
    "${FRONTEND_IMAGE}"

echo
echo "Frontend image scan PASSED."

echo
echo "=============================================="
echo " Image Security Scan Completed"
echo "=============================================="