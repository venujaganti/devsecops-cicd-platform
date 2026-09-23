#!/usr/bin/env bash

set -Eeuo pipefail

echo "========================================"
echo " Frontend Integration Test"
echo "========================================"

FRONTEND_URL="${FRONTEND_URL:-http://localhost}"

echo "Testing frontend: ${FRONTEND_URL}"
echo

if ! command -v curl >/dev/null 2>&1; then
    echo "ERROR: curl is not installed."
    exit 1
fi

HTTP_STATUS="$(curl \
    --silent \
    --show-error \
    --output /tmp/devsecops-frontend.html \
    --write-out "%{http_code}" \
    --max-time 10 \
    "${FRONTEND_URL}/")"

echo "HTTP status: ${HTTP_STATUS}"

if [ "${HTTP_STATUS}" != "200" ]; then
    echo "ERROR: Frontend returned HTTP ${HTTP_STATUS}."
    exit 1
fi

if ! grep -qi "<html" /tmp/devsecops-frontend.html; then
    echo "ERROR: Frontend response does not contain an HTML document."
    exit 1
fi

echo "Frontend integration test PASSED."