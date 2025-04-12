
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import pandas as pd

CSV_URL = 'https://people.sc.fsu.edu/~jburkardt/data/csv/airtravel.csv'

def extract():
    df = pd.read_csv(CSV_URL)
    df.to_csv('/tmp/raw_data.csv', index=False)

def transform():
    df = pd.read_csv('/tmp/raw_data.csv')
    df.columns = [col.lower() for col in df.columns]
    df.to_csv('/tmp/clean_data.csv', index=False)

def load():
    df = pd.read_csv('/tmp/clean_data.csv')
    print(df.head())

default_args = {'start_date': datetime(2024, 1, 1), 'catchup': False}

with DAG('csv_etl_demo',
         default_args=default_args,
         schedule_interval='@daily',
         description='ETL pipeline demo') as dag:

    t1 = PythonOperator(task_id='extract', python_callable=extract)
    t2 = PythonOperator(task_id='transform', python_callable=transform)
    t3 = PythonOperator(task_id='load', python_callable=load)

    t1 >> t2 >> t3
