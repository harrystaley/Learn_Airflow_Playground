#!/bin/bash

set -e

echo "📦 Ensuring Podman is installed..."
if ! command -v podman &> /dev/null; then
  echo "❌ Podman is not installed. Please install it with Homebrew: brew install podman"
  exit 1
fi

ARCH=$(uname -m)
REAL_ARCH=$(arch)
IS_ROSETTA=$(sysctl -in sysctl.proc_translated 2>/dev/null || echo "0")
if [[ "$ARCH" == "x86_64" && "$REAL_ARCH" == "arm64" ]]; then
  ARCH="arm64"
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="${REPO_ROOT}/docker"
COMPOSE_FILE="podman-compose.yaml"

if [[ ! -f "${DOCKER_DIR}/${COMPOSE_FILE}" ]]; then
  echo "❌ Missing ${COMPOSE_FILE} in ${DOCKER_DIR}. Please add it and try again."
  exit 1
fi

if [[ "$ARCH" == "arm64" || "$IS_ROSETTA" == "1" ]]; then
  echo "🍏 Detected Apple Silicon or Rosetta. Using Lima..."

  if ! limactl list | grep -q podman-airflow; then
    limactl start --name=podman-airflow ./lima/lima-podman-config.yaml
  else
    limactl start podman-airflow
  fi

  echo "🔄 Spinning up Airflow containers inside Lima..."
  limactl shell podman-airflow bash <<EOF
cd /Users/$(whoami)/$(basename "$REPO_ROOT")/docker
~/.local/bin/podman-compose -f $COMPOSE_FILE up -d
EOF

else
  echo "🖥️ Running on native Intel. Using Podman machine..."

  if ! podman machine list | grep -q "Running"; then
    podman machine start
  fi

  cd "$DOCKER_DIR"
  podman-compose -f "$COMPOSE_FILE" up -d
fi

echo "✅ Airflow should now be running at: http://localhost:8080"
