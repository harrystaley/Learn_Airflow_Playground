
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
