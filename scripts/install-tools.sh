#!/usr/bin/env bash

set -Eeuo pipefail

echo "=============================================="
echo " DevSecOps Platform - Tool Installation"
echo "=============================================="
echo

if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: Please run this script with sudo or as root."
    echo
    echo "Example:"
    echo "sudo ./scripts/install-tools.sh"
    exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
    echo "ERROR: This script currently supports Ubuntu/Debian systems using apt-get."
    exit 1
fi

echo "Updating package information..."

apt-get update

echo
echo "Installing base packages..."

apt-get install -y \
    curl \
    wget \
    git \
    ca-certificates \
    gnupg \
    jq \
    unzip \
    bash \
    openssl

echo
echo "Installing Podman..."

if command -v podman >/dev/null 2>&1; then
    echo "Podman is already installed."
else
    apt-get install -y podman
fi

echo
echo "Installing kubectl..."

if command -v kubectl >/dev/null 2>&1; then
    echo "kubectl is already installed."
else
    KUBECTL_VERSION="$(curl -L -s https://dl.k8s.io/release/stable.txt)"

    curl -L \
        -o /tmp/kubectl \
        "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

    install -o root -g root -m 0755 \
        /tmp/kubectl \
        /usr/local/bin/kubectl

    rm -f /tmp/kubectl
fi

echo
echo "=============================================="
echo " Installed Tool Versions"
echo "=============================================="

echo
echo "Git:"
git --version

echo
echo "Podman:"
podman --version

echo
echo "kubectl:"
kubectl version --client

echo
echo "=============================================="
echo " Tool Installation Completed"
echo "=============================================="