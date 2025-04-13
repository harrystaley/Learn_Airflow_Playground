# 🌀 Learn Apache Airflow with CeleryExecutor on Podman (Apple Silicon & x86 Ready)

This project helps you deploy **Apache Airflow** using **Podman** on macOS — with support for both **Apple Silicon (M1–M4)** and **x86_64 machines**. It uses `CeleryExecutor`, and includes PostgreSQL, Redis, Flower, and full `podman-compose` compatibility.

---

## 🚀 Features

- ✅ CeleryExecutor-based Airflow deployment
- ✅ PostgreSQL for metadata DB
- ✅ Redis as Celery broker
- ✅ Flower UI for task monitoring
- ✅ `podman-compose` support for both x86 and ARM
- ✅ Lima VM config for native Podman on Apple Silicon
- ✅ Sample DAGs including ETL, sensor, and parallel tasks

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
│   └── podman-compose.yaml
├── plugins/
│   └── my_custom_operator.py
├── setup.sh
├── requirements.txt
├── lima-podman-config.yaml
└── README.md
```

---

## ⚙️ Setup Instructions (x86 or Lima)

### 🔧 On x86 Machines

```bash
cd docker
podman-compose -f podman-compose.yaml up -d
```

### 🍏 On Apple Silicon (M1–M4 Macs)

1. **Install Lima**:

```bash
brew install lima
```

2. **Start the Lima VM with Podman**:

```bash
limactl start --name=podman-airflow --set arch=aarch64 template://podman
```

3. **Shell into the Lima VM**:

```bash
limactl shell podman-airflow
cd /Users/YOUR_USERNAME/path/to/learn_airflow_playground/docker
pip3 install podman-compose
podman-compose -f podman-compose.yaml up -d
```

4. **(Optional) Enable Port Forwarding**:

Add this to your Lima config and restart:

```yaml
portForwards:
  - guestPort: 8080
    hostPort: 8080
  - guestPort: 5555
    hostPort: 5555
```

---

## 🌐 Access Interfaces

| Component     | URL                         | Notes                        |
|---------------|-----------------------------|------------------------------|
| Airflow UI    | http://localhost:8080       | Login: `admin / admin`       |
| Flower UI     | http://localhost:5555       | Celery monitoring dashboard  |

---

## 📦 Python Requirements (for local DAG dev)

```bash
pip install -r requirements.txt
```

---

## 🧪 Included DAGs

| DAG Name              | Description                               |
|------------------------|-------------------------------------------|
| `hello_world`         | Basic BashOperator example                |
| `csv_etl_demo`        | Download, clean, and print a CSV          |
| `s3_sensor_example`   | Waits for an S3 file then runs a command  |
| `parallel_task_demo`  | Demonstrates 3 tasks running in parallel  |

---

## 🧠 Tips for Using Airflow Webserver

- 🧪 Place new DAGs in the `dags/` folder.
- 🔁 If DAGs don't appear, restart the webserver container.
- 🔒 For production: reverse proxy with NGINX or Traefik.

---

## 🍏 Apple Silicon (M1/M2/M3/M4) Setup Tips

If you're on an Apple Silicon Mac, follow these steps to avoid architecture issues with QEMU and Podman:

### ✅ 1. Use the Correct Homebrew Architecture

```bash
/opt/homebrew/bin/brew install qemu
```

Avoid `/usr/local/bin/brew`, which installs x86_64 binaries.

### ✅ 2. Check That QEMU Is ARM-Compatible

```bash
file $(which qemu-system-aarch64)
```

✅ You should see: `Mach-O 64-bit executable arm64`  
❌ If you see `x86_64`, uninstall QEMU and reinstall with the correct brew.

---

## 🧑‍💻 Author

**Harry A. Staley Jr.**  
GitHub: [@harrystaley](https://github.com/harrystaley)  
LinkedIn: [linkedin.com/in/harrystaley](https://linkedin.com/in/harrystaley)

---

## 📚 Resources

- [Apache Airflow Documentation](https://airflow.apache.org/docs/)
- [Podman Docs](https://docs.podman.io/)
- [Colima](https://github.com/abiosoft/colima)
- [Lima](https://github.com/lima-vm/lima)
