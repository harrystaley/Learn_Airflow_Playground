#!/bin/bash

set -e

echo "📦 Ensuring Podman is installed..."
if ! command -v podman &> /dev/null; then
  echo "❌ Podman is not installed. Please install it with Homebrew: brew install podman"
  exit 1
fi

ARCH=$(uname -m)

if [[ "$ARCH" == "arm64" ]]; then
  echo "🍏 Detected Apple Silicon. Starting Lima VM for Podman..."
  if ! limactl list | grep -q podman-airflow; then
    limactl start --name=podman-airflow ./lima/lima-podman-config.yaml
  else
    limactl start podman-airflow
  fi
  limactl shell podman-airflow <<EOF
cd /Users/$(whoami)/$(basename $(pwd))/docker
pip3 install --user podman-compose
podman-compose -f podman-compose.yaml up -d
EOF
else
  echo "🖥️ Detected x86_64 system. Starting containers with Podman directly..."
  cd "$(dirname "$0")/docker"
  podman-compose -f podman-compose.yaml up -d
fi

echo "✅ Airflow should now be running at http://localhost:8080"
