#!/bin/bash

set -Eeuo pipefail

PLUGIN_FILE="$(cd "$(dirname "$0")" && pwd)/plugins.txt"

echo "======================================"
echo " Jenkins Plugin Installation"
echo "======================================"

if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: Please run this script with sudo."
    exit 1
fi

if [ ! -f "${PLUGIN_FILE}" ]; then
    echo "ERROR: plugins.txt was not found: ${PLUGIN_FILE}"
    exit 1
fi

if ! command -v jenkins-plugin-cli >/dev/null 2>&1; then
    echo "ERROR: jenkins-plugin-cli is not installed."
    echo "Install Jenkins first, then run this script again."
    exit 1
fi

if ! systemctl is-active --quiet jenkins; then
    echo "ERROR: Jenkins is not running."
    echo "Start Jenkins first: sudo systemctl start jenkins"
    exit 1
fi

echo "Waiting for Jenkins to become ready..."

for _ in {1..30}; do
    if curl -fsS http://localhost:8080/login >/dev/null 2>&1; then
        break
    fi
    sleep 2
done

if ! curl -fsS http://localhost:8080/login >/dev/null 2>&1; then
    echo "ERROR: Jenkins did not respond on port 8080."
    echo "Check: sudo journalctl -u jenkins -n 100 --no-pager"
    exit 1
fi

echo
echo "Installing plugins from ${PLUGIN_FILE}..."

jenkins-plugin-cli     --plugin-file "${PLUGIN_FILE}"     --verbose

echo
echo "Restarting Jenkins..."
systemctl restart jenkins
sleep 5

if ! systemctl is-active --quiet jenkins; then
    echo "ERROR: Jenkins failed to restart."
    echo "Check: sudo journalctl -u jenkins -n 100 --no-pager"
    exit 1
fi

echo
echo "======================================"
echo " Plugin Installation Completed"
echo "======================================"
