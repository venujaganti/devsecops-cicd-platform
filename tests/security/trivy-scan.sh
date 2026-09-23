#!/usr/bin/env bash

set -Eeuo pipefail

echo "========================================"
echo " Trivy Security Scan"
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

echo "Pulling Trivy image..."

podman pull "${TRIVY_IMAGE}"

echo
echo "Running filesystem vulnerability scan..."

set +e

podman run --rm \
    -v "${PROJECT_ROOT}:/src:ro" \
    -w /src \
    "${TRIVY_IMAGE}" \
    fs \
    --scanners vuln,secret \
    --severity HIGH,CRITICAL \
    --ignore-unfixed \
    --exit-code 1 \
    .

SCAN_RESULT=$?

set -e

echo

if [ "${SCAN_RESULT}" -ne 0 ]; then
    echo "Trivy scan found HIGH or CRITICAL findings."
    exit "${SCAN_RESULT}"
fi

echo "Trivy security scan PASSED."