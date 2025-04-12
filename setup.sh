#!/bin/bash

set -e

mkdir -p ~/airflow/dags ~/airflow/logs ~/airflow/plugins

podman pull apache/airflow:2.8.1-python3.9

podman pod create --name airflow-pod -p 8080:8080 || echo "Pod already exists"

podman run --rm -ti --pod airflow-pod \
  -v ~/airflow:/opt/airflow \
  -e AIRFLOW__CORE__EXECUTOR=CeleryExecutor \
  -e AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=sqlite:////opt/airflow/airflow.db \
  apache/airflow:2.8.1-python3.9 airflow db init

podman run --rm -ti --pod airflow-pod \
  -v ~/airflow:/opt/airflow \
  -e AIRFLOW__CORE__EXECUTOR=CeleryExecutor \
  apache/airflow:2.8.1-python3.9 airflow users create \
  --username admin --password admin \
  --firstname Harry --lastname Staley \
  --role Admin --email harry@example.com

echo "✅ Setup complete. Access the Airflow UI at http://localhost:8080"
