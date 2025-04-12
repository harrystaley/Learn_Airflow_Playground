# learn_airflow_playground/

## 📁 Project Structure (CeleryExecutor Upgrade)

```
learn_airflow_playground/
├── dags/
│   ├── 01_hello_world.py
│   ├── 02_csv_etl.py
│   ├── 03_s3_sensor_example.py
│   └── 04_parallel_tasks.py
├── docker/
│   └── podman-compose.yml
├── plugins/
│   └── my_custom_operator.py
├── setup.sh
├── README.md
└── requirements.txt
```

---

## 📄 `dags/04_parallel_tasks.py`

```python
from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

default_args = {
    'start_date': datetime(2024, 1, 1),
    'catchup': False
}

with DAG('parallel_task_demo',
         default_args=default_args,
         schedule_interval='@daily',
         description='Demonstrate parallel task execution') as dag:

    task_1 = BashOperator(
        task_id='task_1',
        bash_command='sleep 5 && echo "Task 1 complete"'
    )

    task_2 = BashOperator(
        task_id='task_2',
        bash_command='sleep 5 && echo "Task 2 complete"'
    )

    task_3 = BashOperator(
        task_id='task_3',
        bash_command='sleep 5 && echo "Task 3 complete"'
    )

    [task_1, task_2, task_3]
```

---

## 📄 `docker/podman-compose.yml`

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:13
    environment:
      POSTGRES_USER: airflow
      POSTGRES_PASSWORD: airflow
      POSTGRES_DB: airflow
    volumes:
      - pg_data:/var/lib/postgresql/data

  redis:
    image: redis:latest

  airflow-webserver:
    image: apache/airflow:2.8.1-python3.9
    environment:
      AIRFLOW__CORE__EXECUTOR: CeleryExecutor
      AIRFLOW__CORE__SQL_ALCHEMY_CONN: postgresql+psycopg2://airflow:airflow@postgres/airflow
      AIRFLOW__CELERY__BROKER_URL: redis://redis:6379/0
      AIRFLOW__CELERY__RESULT_BACKEND: db+postgresql://airflow:airflow@postgres/airflow
    depends_on:
      - postgres
      - redis
    ports:
      - "8080:8080"
    command: webserver
    volumes:
      - ../dags:/opt/airflow/dags
      - ../plugins:/opt/airflow/plugins
      - ../logs:/opt/airflow/logs

  airflow-scheduler:
    image: apache/airflow:2.8.1-python3.9
    environment:
      AIRFLOW__CORE__EXECUTOR: CeleryExecutor
      AIRFLOW__CORE__SQL_ALCHEMY_CONN: postgresql+psycopg2://airflow:airflow@postgres/airflow
      AIRFLOW__CELERY__BROKER_URL: redis://redis:6379/0
      AIRFLOW__CELERY__RESULT_BACKEND: db+postgresql://airflow:airflow@postgres/airflow
    command: scheduler
    depends_on:
      - postgres
      - redis
    volumes:
      - ../dags:/opt/airflow/dags
      - ../plugins:/opt/airflow/plugins
      - ../logs:/opt/airflow/logs

  airflow-worker:
    image: apache/airflow:2.8.1-python3.9
    environment:
      AIRFLOW__CORE__EXECUTOR: CeleryExecutor
      AIRFLOW__CORE__SQL_ALCHEMY_CONN: postgresql+psycopg2://airflow:airflow@postgres/airflow
      AIRFLOW__CELERY__BROKER_URL: redis://redis:6379/0
      AIRFLOW__CELERY__RESULT_BACKEND: db+postgresql://airflow:airflow@postgres/airflow
    command: celery worker
    depends_on:
      - postgres
      - redis
    volumes:
      - ../dags:/opt/airflow/dags
      - ../plugins:/opt/airflow/plugins
      - ../logs:/opt/airflow/logs

  flower:
    image: apache/airflow:2.8.1-python3.9
    command: celery flower
    ports:
      - "5555:5555"
    environment:
      AIRFLOW__CORE__EXECUTOR: CeleryExecutor
      AIRFLOW__CELERY__BROKER_URL: redis://redis:6379/0
    depends_on:
      - redis
      - airflow-worker

volumes:
  pg_data:
```

---

## 📄 `requirements.txt`

```
apache-airflow==2.8.1
pandas
apache-airflow-providers-amazon
apache-airflow[celery]==2.8.1
```

