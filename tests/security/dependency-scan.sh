#!/usr/bin/env bash

set -Eeuo pipefail

echo "========================================"
echo " Dependency Security Scan"
echo "========================================"

if ! command -v podman >/dev/null 2>&1; then
    echo "ERROR: Podman is not installed."
    exit 1
fi

TRIVY_IMAGE="${TRIVY_IMAGE:-aquasec/trivy:0.67.2}"

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "Project root: ${PROJECT_ROOT}"
echo "Trivy image: ${TRIVY_IMAGE}"
echo

podman pull "${TRIVY_IMAGE}"

echo
echo "Scanning backend dependencies..."

set +e

podman run --rm \
    -v "${PROJECT_ROOT}:/src:ro" \
    -w /src \
    "${TRIVY_IMAGE}" \
    fs \
    --scanners vuln \
    --severity HIGH,CRITICAL \
    --ignore-unfixed \
    --exit-code 1 \
    backend

BACKEND_RESULT=$?

set -e

echo
echo "Backend scan completed with exit code: ${BACKEND_RESULT}"

echo
echo "Scanning frontend dependencies..."

set +e

podman run --rm \
    -v "${PROJECT_ROOT}:/src:ro" \
    -w /src \
    "${TRIVY_IMAGE}" \
    fs \
    --scanners vuln \
    --severity HIGH,CRITICAL \
    --ignore-unfixed \
    --exit-code 1 \
    frontend

FRONTEND_RESULT=$?

set -e

echo
echo "Frontend scan completed with exit code: ${FRONTEND_RESULT}"

if [ "${BACKEND_RESULT}" -ne 0 ] || [ "${FRONTEND_RESULT}" -ne 0 ]; then
    echo
    echo "Dependency security scan FAILED."
    exit 1
fi

echo
echo "Dependency security scan PASSED."