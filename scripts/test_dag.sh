## scripts/test_dag.sh
```bash
#!/bin/bash

# Test all DAGs for syntax errors
echo "Testing DAGs for syntax errors..."

for dag in dags/*.py; do
    echo "Testing $dag..."
    python -m py_compile "$dag"
    if [ $? -eq 0 ]; then
        echo "✓ $dag is valid"
    else
        echo "✗ $dag has errors"
    fi
done

echo "Checking for import errors in Airflow..."
airflow dags list-import-errors
