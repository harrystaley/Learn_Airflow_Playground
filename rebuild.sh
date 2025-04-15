#!/bin/bash

set -e

echo "♻️ Rebuilding Airflow environment from scratch..."

# Clean shutdown
./teardown.sh

# Restart from scratch
echo "🚀 Starting fresh VM and Airflow stack..."
./autostart.sh

echo "✅ Rebuild complete. Visit: http://localhost:8080"
