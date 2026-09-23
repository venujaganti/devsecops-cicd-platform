#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=============================================="
echo " DevSecOps CI/CD Platform - Setup"
echo "=============================================="
echo "Project root: ${PROJECT_ROOT}"
echo

cd "${PROJECT_ROOT}"

echo "Checking required directories..."

REQUIRED_DIRS=(
    "frontend"
    "backend"
    "database"
    "deployment"
    "terraform"
    "jenkins"
    "security"
    "monitoring"
    "tests"
    "scripts"
    ".github/workflows"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "${dir}" ]; then
        echo "ERROR: Required directory not found: ${dir}"
        exit 1
    fi
    echo "PASS: ${dir}"
done

echo
echo "Checking required files..."

REQUIRED_FILES=(
    "podman-compose.yml"
    ".env.example"
    ".gitignore"
    ".containerignore"
    "Jenkinsfile"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "${file}" ]; then
        echo "WARNING: File not found: ${file}"
    else
        echo "PASS: ${file}"
    fi
done

echo
echo "Checking Podman..."

if command -v podman >/dev/null 2>&1; then
    podman --version
else
    echo "ERROR: Podman is not installed."
    echo "Run: ./scripts/install-tools.sh"
    exit 1
fi

echo
echo "Checking kubectl..."

if command -v kubectl >/dev/null 2>&1; then
    kubectl version --client
else
    echo "WARNING: kubectl is not installed."
fi

echo
echo "Checking Git..."

if command -v git >/dev/null 2>&1; then
    git --version
else
    echo "WARNING: Git is not installed."
fi

echo
echo "=============================================="
echo " Setup Check Completed"
echo "=============================================="