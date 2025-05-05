#!/bin/bash

# Setup script for Airflow project

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3.11 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install requirements
pip install -r requirements.txt

# Set Airflow home to project directory
export AIRFLOW_HOME=$(pwd)

# Create symbolic link to DAGs
ln -sf $(pwd)/dags $AIRFLOW_HOME/dags

# Initialize Airflow database
airflow db init

echo "Airflow setup complete!"
echo "To start Airflow:"
echo "  Terminal 1: airflow webserver --port 8080"
echo "  Terminal 2: airflow scheduler"
