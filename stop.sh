#!/bin/bash

set -e

echo "🛑 Stopping Airflow containers..."

# Handle Rosetta detection
ARCH=$(uname -m)
REAL_ARCH=$(arch)
IS_ROSETTA=$(sysctl -in sysctl.proc_translated 2>/dev/null || echo "0")
if [[ "$ARCH" == "x86_64" && "$REAL_ARCH" == "arm64" ]]; then
  ARCH="arm64"
fi

# Define project path
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIMA_PROJECT_DIR="/Users/$(whoami)${REPO_ROOT#"$HOME"}/docker"
COMPOSE_FILE="podman-compose.yaml"

# Use Lima on Apple Silicon or Rosetta
if [[ "$ARCH" == "arm64" || "$IS_ROSETTA" == "1" ]]; then
  echo "🍏 Detected Apple Silicon or Rosetta. Stopping via Lima..."

  limactl shell podman-airflow bash <<EOF
cd "$LIMA_PROJECT_DIR"

if [[ -f podman-compose.yaml ]]; then
  ~/.local/bin/podman-compose -f podman-compose.yaml down
else
  echo "⚠️ No podman-compose.yaml found in $LIMA_PROJECT_DIR"
fi
EOF

  echo "🛑 Stopping Lima VM..."
  limactl stop podman-airflow

else
  echo "🖥️ Detected native Intel. Stopping via Podman machine..."

  if podman machine list | grep -q "Running"; then
    cd "${REPO_ROOT}/docker"
    if [[ -f podman-compose.yaml ]]; then
      podman-compose -f podman-compose.yaml down
    else
      echo "⚠️ No podman-compose.yaml found in ./docker"
    fi

    echo "🛑 Stopping Podman machine..."
    podman machine stop
  else
    echo "ℹ️ Podman machine is already stopped."
  fi
fi

echo "✅ All containers and VM have been stopped."
