#!/bin/bash

set -e

LOG_FILE="/var/log/devsecops-user-data.log"

exec > >(tee -a "$LOG_FILE")
exec 2>&1

echo "Starting DevSecOps EC2 initialization..."

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get upgrade -y

apt-get install -y \
  curl \
  wget \
  git \
  unzip \
  jq \
  ca-certificates \
  gnupg \
  lsb-release \
  apt-transport-https

echo "Installing Java..."

apt-get install -y openjdk-17-jdk

echo "Installing Python..."

apt-get install -y python3 python3-pip python3-venv

echo "Installing Node.js..."

curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt-get install -y nodejs

echo "Installing Maven..."

apt-get install -y maven

echo "Installing Podman..."

apt-get install -y podman

echo "Installing kubectl..."

KUBECTL_VERSION="$(curl -L -s https://dl.k8s.io/release/stable.txt)"

curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

rm -f kubectl

echo "Creating DevSecOps application directory..."

mkdir -p /opt/devsecops-cicd-platform

chmod 755 /opt/devsecops-cicd-platform

echo "Installation verification..."

java -version || true
python3 --version || true
node --version || true
npm --version || true
mvn --version || true
podman --version || true
kubectl version --client || true
git --version || true

echo "DevSecOps EC2 initialization completed."

touch /opt/devsecops-cicd-platform/initialized

echo "Initialization completed successfully."