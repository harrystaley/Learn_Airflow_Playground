#!/bin/bash

ENV=$1
if [ -z "$ENV" ]; then
    echo "Usage: source scripts/set_env.sh [dev|prod]"
    return 1
fi

export AIRFLOW_HOME=$(pwd)
export AIRFLOW_CONFIG=$(pwd)/config/environments/${ENV}.cfg
echo "Environment set to: $ENV"
