#!/bin/bash

set -e

echo "🛑 Shutting down Airflow and cleaning up..."

# Detect and stop Lima
if limactl list | grep -q podman-airflow; then
  echo "📦 Stopping Lima VM podman-airflow..."
  limactl stop podman-airflow || true
  limactl delete podman-airflow || true
else
  echo "ℹ️ Lima VM podman-airflow not found. Skipping."
fi

# Detect and stop Podman machine (Intel fallback)
if podman machine list | grep -q "Running"; then
  echo "🧹 Stopping Podman machine..."
  podman machine stop || true
fi

echo "🧼 Reset complete. VM and containers removed."
