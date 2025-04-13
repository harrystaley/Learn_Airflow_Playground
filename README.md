# Learn_Airflow_Playground

## Project Overview

Welcome to the Learn_Airflow_Playground repository! This project is designed as a hands-on playground for learning and experimenting with Apache Airflow, an open-source tool that helps you orchestrate complex computational workflows and data processing pipelines.

The structure of this repository is organized as follows:

- **dags/**: Contains all the Directed Acyclic Graphs (DAGs) examples which you can use to understand how to structure workflows in Airflow.
- **plugins/**: Here, you can find custom plugins that extend the functionality of Airflow.
- **scripts/**: Includes various scripts to help set up, configure, or deploy Airflow environments.
- **docs/**: Documentation related to the workflows, including setup guides and usage examples.

## Setup and Installation

### Prerequisites

Before you begin, ensure you have the following installed on your system:
- Python (3.6, 3.7, 3.8)
- pip
- Docker (optional, for container-based deployment)

### Installation Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/Learn_Airflow_Playground.git
   cd Learn_Airflow_Playground
   ```

2. **Set up a virtual environment (optional but recommended):**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows use `.\venv\Scripts\activate`
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Initialize Airflow:**
   ```bash
   airflow db init
   airflow users create --username admin --password admin --firstname FIRST_NAME --lastname LAST_NAME --role Admin --email EMAIL@example.com
   ```

5. **Start the Airflow web server:**
   ```bash
   airflow webserver --port 8080
   ```

6. **In a new terminal, start the Airflow scheduler:**
   ```bash
   airflow scheduler
   ```

### Docker Setup (Optional)

If you prefer using Docker, you can use the provided Dockerfile to build and run Airflow in a containerized environment:

```bash
docker build -t learn_airflow .
docker run -p 8080:8080 learn_airflow
```

## Usage Examples

To test if your installation was successful and Airflow is running correctly, try executing one of the example DAGs included in the `dags/` directory.

1. **Access the Airflow web interface:**
   - Open a web browser and visit `http://localhost:8080`.
   - Log in with the credentials you created during setup.

2. **Enable and trigger a DAG:**
   - Navigate to the 'DAGs' tab.
   - Find an example DAG, click the toggle to enable it, and then trigger it manually.

3. **Monitor the DAG:**
   - Click on the DAG to view its current status, logs, and detailed task information.

## Contribution Guidelines

Contributions to the Learn_Airflow_Playground are welcome! Here are a few guidelines to follow:

1. **Fork the repository** and create your branch from `main`.
2. **Add or update tests** as appropriate for your changes.
3. Ensure that your code adheres to the existing style.
4. Include documentation for new or existing features.
5. Submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Happy Learning and Experimenting with Apache Airflow!