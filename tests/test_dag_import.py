from airflow.models.dagbag import DagBag

def test_dag_import():
    dag_bag = DagBag()
    assert len(dag_bag.dags) > 0, "No DAGs were loaded"
    assert "example_dag" in dag_bag.dags
