#!/bin/bash

set -e

echo "📦 Ensuring Podman is installed..."
if ! command -v podman &> /dev/null; then
  echo "❌ Podman is not installed. Please install it with Homebrew: brew install podman"
  exit 1
fi

# Detect architecture and Rosetta
ARCH=$(uname -m)
REAL_ARCH=$(arch)
IS_ROSETTA=$(sysctl -in sysctl.proc_translated 2>/dev/null || echo "0")
if [[ "$ARCH" == "x86_64" && "$REAL_ARCH" == "arm64" ]]; then
  ARCH="arm64"
fi

# Define project paths
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="${REPO_ROOT}/docker"
COMPOSE_FILE="podman-compose.yaml"
LIMA_CONFIG="${REPO_ROOT}/lima/lima-podman-config.yaml"

# Validate that the compose file exists
if [[ ! -f "${DOCKER_DIR}/${COMPOSE_FILE}" ]]; then
  echo "❌ Missing ${COMPOSE_FILE} in ${DOCKER_DIR}. Please add it and try again."
  exit 1
fi

# Construct Lima path
LIMA_PROJECT_DIR="/Users/$(whoami)${REPO_ROOT#"$HOME"}/docker"

# Use Lima on Apple Silicon
if [[ "$ARCH" == "arm64" || "$IS_ROSETTA" == "1" ]]; then
  echo "🍏 Detected Apple Silicon or Rosetta. Using Lima with Podman..."

  # Fully recreate the Lima VM to ensure portForwards apply
  if limactl list | grep -q podman-airflow; then
    echo "🧼 Removing existing Lima VM podman-airflow..."
    limactl stop podman-airflow || true
    limactl delete podman-airflow || true
  fi

  echo "🚀 Creating Lima VM with updated config..."
  limactl start --name=podman-airflow "$LIMA_CONFIG"

  echo "🔄 Spinning up Airflow containers inside Lima..."

  limactl shell podman-airflow bash <<EOF
set -e
cd "$LIMA_PROJECT_DIR"

if [[ ! -f podman-compose.yaml ]]; then
  echo "❌ podman-compose.yaml not found in $LIMA_PROJECT_DIR"
  exit 1
fi

echo "✅ Running podman-compose up..."
~/.local/bin/podman-compose -f podman-compose.yaml up -d
EOF

else
  echo "🖥️ Detected native Intel. Using Podman machine..."

  if ! podman machine list | grep -q "Running"; then
    echo "🚀 Starting Podman machine..."
    podman machine start
  fi

  cd "$DOCKER_DIR"
  podman-compose -f "$COMPOSE_FILE" up -d
fi

echo "✅ Airflow should now be running at: http://localhost:8080"
