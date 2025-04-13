# 🌀 Learn Apache Airflow with CeleryExecutor on Podman

This project sets up an **enterprise-style Apache Airflow environment** using **Podman** with **CeleryExecutor**, backed by **PostgreSQL** and **Redis**. It's designed to help you learn how Airflow is used in real-world distributed and scalable systems.

---

## 🚀 Features

- ✅ Airflow 2.8.1 with CeleryExecutor
- ✅ Redis as Celery broker
- ✅ PostgreSQL as metadata DB
- ✅ Flower monitoring dashboard on port `5555`
- ✅ Modular DAG examples (ETL, sensors, parallel execution)
- ✅ `podman-compose`-compatible

---

## 🧰 Prerequisites

- Podman & Podman Compose
- Python 3.8+
- Internet connection (for pulling images)

---

## 📁 Project Structure

```
learn_airflow_playground/
├── dags/
│   ├── 01_hello_world.py
│   ├── 02_csv_etl.py
│   ├── 03_s3_sensor_example.py
│   └── 04_parallel_tasks.py
├── docker/
│   └── podman-compose.yml
├── plugins/
│   └── my_custom_operator.py
├── setup.sh
├── requirements.txt
└── README.md
```

---

## ⚙️ Setup Instructions

```bash
# Clone and navigate
unzip learn_airflow_playground.zip
cd learn_airflow_playground

# Initialize project directories, pull images, and create Airflow user
bash setup.sh

# Start all services with Podman Compose
cd docker
podman-compose up -d
```

---

## 🌐 Access Interfaces

| Component     | URL                         | Notes                        |
|---------------|-----------------------------|------------------------------|
| Airflow UI    | http://localhost:8080       | Login: `admin / admin`       |
| Flower UI     | http://localhost:5555       | Monitor Celery workers/tasks |

---

## 🧪 Included DAGs

| DAG Name              | Description                               |
|------------------------|-------------------------------------------|
| `hello_world`         | Basic BashOperator example                |
| `csv_etl_demo`        | Download, clean, and print a CSV          |
| `s3_sensor_example`   | Waits for an S3 file then runs a command  |
| `parallel_task_demo`  | Demonstrates 3 tasks running in parallel  |

---

## 📦 Python Requirements

If you want to install locally (e.g. for testing DAGs):

```bash
pip install -r requirements.txt
```

---

## 🧑‍💻 Author

**Harry A. Staley Jr.**  
GitHub: [@harrystaley](https://github.com/harrystaley)  
LinkedIn: [linkedin.com/in/harrystaley](https://linkedin.com/in/harrystaley)

---

## 🛠️ Future Ideas

- Add Kubernetes YAML for `podman play kube`
- Integrate with GitHub Actions to auto-deploy DAGs
- Add Airflow REST API usage examples

---


---

## 🌐 Airflow Webserver Overview

The **Airflow Webserver** is your control panel for managing workflows.

### 🔍 Key Features
| Feature                    | Description                                                                 |
|---------------------------|-----------------------------------------------------------------------------|
| 🌳 Browse DAGs             | View and manage all registered DAGs                                        |
| 🧠 Trigger DAGs manually   | Execute workflows on-demand for testing or production                      |
| 📊 Monitor task status     | Check logs, status, Gantt charts, and retry history                        |
| ⚙️ Configure variables     | Set Airflow variables and connections via the UI                           |
| 👤 Role-based access       | RBAC enabled to control user and group permissions                         |

### ⚙️ Setup Details in This Project

The `airflow-webserver` is defined in `podman-compose.yml` and exposed on port `8080`.

```yaml
airflow-webserver:
  image: apache/airflow:2.8.1-python3.9
  ports:
    - "8080:8080"
  command: webserver
```

- Accessible at: [http://localhost:8080](http://localhost:8080)
- Default credentials:
    - **Username:** `admin`
    - **Password:** `admin`

### 🛠️ Pro Tips
- 🧪 Place new DAG files into the `dags/` directory. They will auto-refresh.
- 🔁 Restart the webserver if DAGs don’t appear immediately.
- 🔒 In production, proxy the UI with **NGINX** or **Traefik** for HTTPS and load balancing.
- 📈 Logs are written to `logs/` and can be tailed live.

Let me know if you'd like to:
- Add Flower or Prometheus health checks
- Enable TLS/HTTPS with reverse proxy
- Integrate OAuth2 or LDAP for enterprise SSO
