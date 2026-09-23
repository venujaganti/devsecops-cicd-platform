#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive

JENKINS_REPO_KEY="/usr/share/keyrings/jenkins-keyring.asc"
JENKINS_REPO="/etc/apt/sources.list.d/jenkins.list"

echo "======================================"
echo " Jenkins Installation"
echo "======================================"

# Make sure the script is running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: Please run this script with sudo."
    echo "Example:"
    echo "sudo ./install-jenkins.sh"
    exit 1
fi

echo "[1/8] Updating package lists..."

apt-get update -y

echo "[2/8] Installing required packages..."

apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    git \
    wget \
    fontconfig \
    openjdk-17-jre

echo "[3/8] Checking Java installation..."

if ! command -v java >/dev/null 2>&1; then
    echo "ERROR: Java installation failed."
    exit 1
fi

java -version

echo "[4/8] Installing Jenkins repository key..."

install -d -m 0755 /usr/share/keyrings

curl -fsSL \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key \
    -o "${JENKINS_REPO_KEY}"

chmod 0644 "${JENKINS_REPO_KEY}"

echo "[5/8] Configuring Jenkins repository..."

echo "deb [signed-by=${JENKINS_REPO_KEY}] https://pkg.jenkins.io/debian-stable binary/" \
    > "${JENKINS_REPO}"

echo "[6/8] Updating package lists..."

apt-get update -y

echo "[7/8] Installing Jenkins..."

apt-get install -y jenkins

echo "[8/8] Starting Jenkins..."

systemctl daemon-reload
systemctl enable jenkins
systemctl restart jenkins

echo "Waiting for Jenkins to start..."

sleep 10

if systemctl is-active --quiet jenkins; then

    echo
    echo "======================================"
    echo " Jenkins Installation Successful"
    echo "======================================"

    echo
    echo "Jenkins status:"
    systemctl is-active jenkins

    echo
    echo "Java version:"
    java -version

    echo
    echo "Jenkins version:"
    jenkins --version || true

    echo
    echo "Initial Jenkins Administrator Password:"
    echo "----------------------------------------"

    if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
        cat /var/lib/jenkins/secrets/initialAdminPassword
    else
        echo "Password file is not available yet."
        echo "Run:"
        echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
    fi

    echo
    echo "Jenkins is running on port 8080."
    echo
    echo "Open in your browser:"
    echo "http://EC2_PUBLIC_IP:8080"
    echo

else

    echo
    echo "======================================"
    echo " ERROR: Jenkins failed to start"
    echo "======================================"

    echo
    echo "Check Jenkins status:"
    echo "sudo systemctl status jenkins"

    echo
    echo "Check Jenkins logs:"
    echo "sudo journalctl -u jenkins -n 100 --no-pager"

    exit 1

fi