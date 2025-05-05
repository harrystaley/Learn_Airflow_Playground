# Airflow Project

This repository contains DAGs, plugins, and configuration for our Airflow deployment.

## Structure

```
airflow-project/
├── dags/                 # Airflow DAGs
├── plugins/              # Custom plugins and operators
├── config/               # Configuration files
├── data/                 # Data files (gitignored if sensitive)
├── scripts/              # Utility scripts
└── requirements.txt      # Python dependencies
```

## Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/airflow-project.git
   cd airflow-project
   ```

2. Create and activate virtual environment:
   ```bash
   python3.11 -m venv venv
   source venv/bin/activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Initialize Airflow:
   ```bash
   export AIRFLOW_HOME=$(pwd)
   airflow db init
   ```

5. Create an admin user:
   ```bash
   airflow users create \
       --username admin \
       --password admin \
       --firstname Admin \
       --lastname User \
       --role Admin \
       --email admin@example.com
   ```

6. Link DAGs directory:
   ```bash
   ln -sf $(pwd)/dags $AIRFLOW_HOME/dags
   ```

7. Start Airflow:
   ```bash
   # Terminal 1
   airflow webserver --port 8080
   
   # Terminal 2
   airflow scheduler
   ```

8. Access Airflow UI at `http://localhost:8080`

## Development

### Adding New DAGs

1. Create a new DAG file in the `dags/` directory
2. Test it with:
   ```bash
   python -m py_compile dags/your_new_dag.py
   ```
3. Run validation script:
   ```bash
   ./scripts/test_dag.sh
   ```

### Best Practices

- Follow PEP8 style guidelines
- Use descriptive task IDs
- Include proper error handling
- Document complex DAGs
- Use environment variables for sensitive data

## Project Management

### Testing

```bash
# Test specific DAG
airflow dags test my_dag_id 2024-01-01

# List import errors
airflow dags list-import-errors

# Run test script
./scripts/test_dag.sh
```

### Deployment

1. Create a new branch for your feature
2. Test locally
3. Create pull request
4. Review and merge
5. Deploy to production

### Monitoring

- Check logs in `logs/` directory
- Monitor DAG runs in the UI
- Set up alerting for critical failures

## Environment Configuration

### Development
```bash
# Copy example config
cp config/airflow.cfg.example config/airflow.cfg

# Set development environment
source scripts/set_env.sh dev
```

### Production
```bash
# Set production environment
source scripts/set_env.sh prod
```

## Troubleshooting

### Common Issues

1. **DAG import errors**
   ```bash
   airflow dags list-import-errors
   ```

2. **Database connection issues**
   ```bash
   airflow db check
   ```

3. **Scheduler not running**
   ```bash
   ps aux | grep airflow
   ```

### Logs

- Webserver logs: `logs/webserver/`
- Scheduler logs: `logs/scheduler/`
- Task logs: `logs/dag_id/task_id/`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For questions or support, please contact:
- Email: your-email@example.com
- Slack: #airflow-support

## Acknowledgments

- Apache Airflow community
- Contributors and maintainers
