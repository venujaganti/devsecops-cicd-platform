#!/usr/bin/env bash

set -Eeuo pipefail

echo "========================================"
echo " API Integration Test"
echo "========================================"

API_URL="${API_URL:-http://localhost:8000}"
HEALTH_URL="${API_URL%/}/health"

echo "Testing API: ${HEALTH_URL}"
echo

if ! command -v curl >/dev/null 2>&1; then
    echo "ERROR: curl is not installed."
    exit 1
fi

HTTP_STATUS="$(curl \
    --silent \
    --show-error \
    --output /tmp/devsecops-api-health.json \
    --write-out "%{http_code}" \
    --max-time 10 \
    "${HEALTH_URL}")"

echo "HTTP status: ${HTTP_STATUS}"

if [ "${HTTP_STATUS}" != "200" ]; then
    echo "ERROR: API health check failed."
    echo "Response:"
    cat /tmp/devsecops-api-health.json
    echo
    exit 1
fi

echo "Response:"
cat /tmp/devsecops-api-health.json
echo
echo "API integration test PASSED."