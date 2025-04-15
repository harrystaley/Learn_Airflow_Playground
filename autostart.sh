#!/bin/bash

set -e

echo "📦 Ensuring Podman is installed..."
if ! command -v podman &> /dev/null; then
  echo "❌ Podman is not installed. Please install it with Homebrew: brew install podman"
  exit 1
fi

# Handle Rosetta detection
ARCH=$(uname -m)
REAL_ARCH=$(arch)
IS_ROSETTA=$(sysctl -in sysctl.proc_translated 2>/dev/null || echo "0")
if [[ "$ARCH" == "x86_64" && "$REAL_ARCH" == "arm64" ]]; then
  ARCH="arm64"
fi

# Define host-side paths
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="${REPO_ROOT}/docker"
COMPOSE_FILE="podman-compose.yaml"

# Validate the compose file exists on host
if [[ ! -f "${DOCKER_DIR}/${COMPOSE_FILE}" ]]; then
  echo "❌ Missing ${COMPOSE_FILE} in ${DOCKER_DIR}. Please add it and try again."
  exit 1
fi

# Construct Lima path relative to $HOME
LIMA_PROJECT_DIR="/Users/$(whoami)${REPO_ROOT#"$HOME"}/docker"

# Apple Silicon (native or via Rosetta)
if [[ "$ARCH" == "arm64" || "$IS_ROSETTA" == "1" ]]; then
  echo "🍏 Detected Apple Silicon or Rosetta. Using Lima..."

  # Start or reuse the Lima VM
  if ! limactl list | grep -q podman-airflow; then
    limactl start --name=podman-airflow ./lima/lima-podman-config.yaml
  else
    limactl start podman-airflow
  fi

  echo "🔄 Spinning up Airflow containers inside Lima..."

  # Run Airflow via podman-compose inside Lima
  limactl shell podman-airflow bash <<EOF
cd "$LIMA_PROJECT_DIR"

if [[ ! -f podman-compose.yaml ]]; then
  echo "❌ podman-compose.yaml not found in $LIMA_PROJECT_DIR"
  exit 1
fi

~/.local/bin/podman-compose -f podman-compose.yaml up -d
EOF

else
  echo "🖥️ Running on native Intel. Using Podman machine..."

  if ! podman machine list | grep -q "Running"; then
    echo "🚀 Starting Podman machine..."
    podman machine start
  fi

  cd "$DOCKER_DIR"
  podman-compose -f "$COMPOSE_FILE" up -d
fi

echo "✅ Airflow should now be running at: http://localhost:8080"
