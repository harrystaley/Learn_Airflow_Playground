
from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

default_args = {
    'start_date': datetime(2024, 1, 1),
    'catchup': False
}

with DAG('hello_world',
         default_args=default_args,
         schedule_interval='@daily',
         description='A simple hello world DAG') as dag:

    say_hello = BashOperator(
        task_id='say_hello',
        bash_command='echo "Hello from Airflow!"'
    )
