
from airflow.models import BaseOperator

class MyCustomOperator(BaseOperator):
    def __init__(self, message: str, **kwargs):
        super().__init__(**kwargs)
        self.message = message

    def execute(self, context):
        print(f"👋 {self.message}")
