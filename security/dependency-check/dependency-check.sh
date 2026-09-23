#!/bin/bash

set -euo pipefail

echo "=============================================="
echo " OWASP Dependency-Check"
echo " DevSecOps CI/CD Platform"
echo "=============================================="

# Find the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find project root
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Report directory
REPORT_DIR="${PROJECT_ROOT}/security/dependency-check/reports"

# Dependency-Check container image
IMAGE="owasp/dependency-check:latest"

# Project name
PROJECT_NAME="devsecops-cicd-platform"

# Fail when CVSS score is 7.0 or higher
FAIL_ON_CVSS="7"

echo
echo "[1/5] Checking Podman..."

if ! command -v podman >/dev/null 2>&1; then
    echo "ERROR: Podman is not installed."
    echo "Please install Podman and run this script again."
    exit 1
fi

podman --version

echo
echo "[2/5] Creating report directory..."

mkdir -p "${REPORT_DIR}"

echo "Report directory:"
echo "${REPORT_DIR}"

echo
echo "[3/5] Pulling OWASP Dependency-Check image..."

podman pull "${IMAGE}"

echo
echo "[4/5] Running dependency scan..."

podman run --rm \
    -v "${PROJECT_ROOT}:/src:Z" \
    "${IMAGE}" \
    --project "${PROJECT_NAME}" \
    --scan /src/backend \
    --scan /src/frontend \
    --format HTML \
    --format JSON \
    --out /src/security/dependency-check/reports \
    --failOnCVSS "${FAIL_ON_CVSS}" \
    --disableOssIndex \
    --disableRetireJs

echo
echo "[5/5] Checking generated reports..."

if [ -f "${REPORT_DIR}/dependency-check-report.html" ]; then
    echo "HTML report created successfully."
else
    echo "WARNING: HTML report was not found."
fi

if [ -f "${REPORT_DIR}/dependency-check-report.json" ]; then
    echo "JSON report created successfully."
else
    echo "WARNING: JSON report was not found."
fi

echo
echo "=============================================="
echo " Dependency-Check Scan Completed"
echo "=============================================="

echo
echo "Reports:"
echo "${REPORT_DIR}"