# Learn Airflow Playground

A fully containerized development and experimentation environment for **Apache Airflow 3** using **Podman Compose** and **Miniconda**. Designed for repeatable setups on macOS and Linux.

---

## 🔧 Requirements

- [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
- [Podman](https://podman.io/)
- [podman-compose](https://github.com/containers/podman-compose)

---

## 🚀 Installation

### 1. Clone the repository

```bash
git clone https://github.com/your-username/Learn_Airflow_Playground.git
cd Learn_Airflow_Playground
```

### 2. Set up the environment and start Airflow

```bash
conda env create -f environment.yml
conda activate airflow-playground
podman-compose up --build
```

> ⚠️ **First-time setup**: The images will be built and dependencies installed; this can take several minutes.

---

## 📁 Project Structure

```text
.
├── airflow/                 
│   ├── dags/                # DAG files (with version metadata)
│   ├── plugins/             # Custom plugins
│   └── airflow.cfg          # Optional config overrides
├── docker/
│   ├── Dockerfile           # Custom Airflow 3 image
│   └── entrypoint.sh
├── logs/                    # Logs (volume mounted)
├── .env                     # Podman Compose environment variables
├── environment.yml          # Conda environment setup
├── podman-compose.yaml      # Service definition
└── README.md
```

---

## 🧪 DAG Versioning (Airflow 3 Feature)

DAGs are versioned using the `version` argument:

```python
with DAG(
    dag_id="example_dag",
    version="1.0.0",
    start_date=datetime(2024, 1, 1),
    schedule="@daily",
    catchup=False,
) as dag:
    ...
```

To enforce consistency, consider automating the version from a Git tag or commit hash.

---

## 🧪 Development Tips

- Run all unit tests:

```bash
pytest tests/
```

- Stop services:

```bash
podman-compose down
```

- Reset everything:

```bash
podman-compose down -v
podman volume prune
```

- Update a DAG and reload via the UI or restart scheduler:

```bash
podman exec -it <scheduler-container> pkill -HUP -f airflow
```

---

## ✅ Features

- Airflow **3.x** (CeleryExecutor)
- PostgreSQL + Redis backend
- Podman-native (no Docker required)
- Conda-managed Python dependencies
- Git-based DAG versioning support
- Clean modular directory structure for plugins and DAGs

---

## 🛠️ Troubleshooting

- **Podman machine not started**  
  Run:

  ```bash
  podman machine start
  ```

- **Port conflicts**  
  Make sure ports `8080`, `5432`, and `6379` aren’t in use.

- **Volume/log permission issues**  
  Try:
  
  ```bash
  chmod -R 777 logs/
  ```

---

## 📚 References

- [Apache Airflow 3 Docs](https://airflow.apache.org/docs/)
- [Airflow DAG Versioning](https://airflow.apache.org/docs/apache-airflow/stable/authoring-and-scheduling/dag-versioning.html)
- [Podman Compose Guide](https://github.com/containers/podman-compose)
- [Miniconda Docs](https://docs.conda.io/en/latest/)

---

## 🙌 Contributing

Contributions are welcome! Open an issue or pull request if you have improvements or fixes.

---

## 📝 License

MIT License
