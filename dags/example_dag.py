from airflow.decorators import dag
from airflow.operators.empty import EmptyOperator
from datetime import datetime

@dag(
    dag_id="example_dag",
    start_date=datetime(2024, 1, 1),
    schedule="@daily",
    catchup=False,
    tags=["example"]
)
def example_dag():
    start = EmptyOperator(task_id="start")
    end = EmptyOperator(task_id="end")
    start >> end

dag = example_dag()
