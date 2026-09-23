#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

BACKEND_IMAGE="${BACKEND_IMAGE:-devsecops-backend:latest}"
FRONTEND_IMAGE="${FRONTEND_IMAGE:-devsecops-frontend:latest}"

echo "=============================================="
echo " DevSecOps Platform - Build Images"
echo "=============================================="

cd "${PROJECT_ROOT}"

if ! command -v podman >/dev/null 2>&1; then
    echo "ERROR: Podman is not installed."
    exit 1
fi

echo
echo "Podman version:"
podman --version

echo
echo "----------------------------------------------"
echo "Building backend image"
echo "----------------------------------------------"

if [ ! -f "backend/Containerfile" ]; then
    echo "ERROR: backend/Containerfile not found."
    exit 1
fi

podman build \
    --tag "${BACKEND_IMAGE}" \
    --file backend/Containerfile \
    backend

echo
echo "Backend image built:"
echo "${BACKEND_IMAGE}"

echo
echo "----------------------------------------------"
echo "Building frontend image"
echo "----------------------------------------------"

if [ ! -f "frontend/Containerfile" ]; then
    echo "ERROR: frontend/Containerfile not found."
    exit 1
fi

podman build \
    --tag "${FRONTEND_IMAGE}" \
    --file frontend/Containerfile \
    frontend

echo
echo "Frontend image built:"
echo "${FRONTEND_IMAGE}"

echo
echo "----------------------------------------------"
echo "Images"
echo "----------------------------------------------"

podman images \
    --filter "reference=${BACKEND_IMAGE}"

podman images \
    --filter "reference=${FRONTEND_IMAGE}"

echo
echo "=============================================="
echo " Image Build Completed Successfully"
echo "=============================================="