
from airflow import DAG
from airflow.providers.amazon.aws.sensors.s3_key import S3KeySensor
from airflow.operators.bash import BashOperator
from datetime import datetime

default_args = {'start_date': datetime(2024, 1, 1), 'catchup': False}

with DAG('s3_sensor_example',
         default_args=default_args,
         schedule_interval='@hourly',
         description='Wait for S3 file and process it') as dag:

    wait_for_file = S3KeySensor(
        task_id='wait_for_s3_file',
        bucket_key='data/trigger.csv',
        bucket_name='my-bucket',
        aws_conn_id='aws_default',
        timeout=60*60,
        poke_interval=60
    )

    process_file = BashOperator(
        task_id='process_file',
        bash_command='echo "Processing file..."'
    )

    wait_for_file >> process_file
