from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from datetime import datetime
import logging

def extract():
    logging.info("Extracting data")
    return "apple,banana,orange,kiwi"

def transform(ti):
    logging.info("Loading data")
    data=ti.xcom_pull(task_ids="extract")
    transformed_data=data.upper()
    return transformed_data

def load(ti):
    logging.info("Loading data")
    final_data=ti.xcom_pull(task_ids="transform")
    logging.info(f"Final data: {final_data}")


with DAG(
    dag_id="etl_dag_one",
    start_date=datetime(2025,1,1),
    schedule_interval=None,
    catchup=False,
) as dag:
    
    t1 = PythonOperator(
        task_id="extract",
        python_callable=extract
    )

    t2 = BashOperator(
        task_id="bash_msg",
        bash_command='echo "running from bash task"'
    )

    t3 = PythonOperator(
        task_id="transform",
        python_callable=transform
    )

    t4 = PythonOperator(
        task_id="load",
        python_callable=load
    )

    t1 >> t2 >> t3 >> t4