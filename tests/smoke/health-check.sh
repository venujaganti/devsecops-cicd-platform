#!/usr/bin/env bash

set -Eeuo pipefail

echo "========================================"
echo " DevSecOps Health Check"
echo "========================================"

API_URL="${API_URL:-http://localhost:8000}"
FRONTEND_URL="${FRONTEND_URL:-http://localhost}"

FAILED=0

check_url() {
    local name="$1"
    local url="$2"

    echo
    echo "Checking ${name}: ${url}"

    if curl \
        --silent \
        --show-error \
        --fail \
        --max-time 10 \
        "${url}" \
        >/dev/null; then

        echo "PASS: ${name}"
    else
        echo "FAIL: ${name}"
        FAILED=1
    fi
}

if ! command -v curl >/dev/null 2>&1; then
    echo "ERROR: curl is not installed."
    exit 1
fi

check_url "Backend API" "${API_URL%/}/health"
check_url "Frontend" "${FRONTEND_URL%/}/health"

echo

if [ "${FAILED}" -ne 0 ]; then
    echo "Health check FAILED."
    exit 1
fi

echo "All health checks PASSED."