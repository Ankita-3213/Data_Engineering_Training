from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta
import json
import random

default_args = {
    "owner": "ankita", "email":["ankita@example.com"], "email_on_failure":True, "retries":2, "retry_delay":timedelta(minutes=2)
}

def pull_data():
    print("Pulling data from external source")
    data={"timestamp":datetime.now().isoformat(), "value":random.randint(50,150)}
    print(f"Data pulled: {data}")
    return data

def audit_rule_validation(ti):
    print("Validating business rules")
    data = ti.xcom_pull(task_ids="data_pull")
    if data["value"] > 100:
        print(f"Validation failed. Value is {data['value']}")
        raise ValueError("Audit validation failed ")
    audit_result = {"status":"PASS", "value":data["value"], "timestamp":data["timestamp"]}
    with open("/tmp/audit_result.json","w")as file:
        json.dump(audit_result, file)
    print(f"Audit result saved: {audit_result}")
    return audit_result

def final_status_update(ti):
    result=ti.xcom_pull(task_ids="audit_validation")
    print(f"Final Audit status: {result['status']}")


with DAG(
    dag_id="data_audit_dag",
    default_args=default_args,
    start_date=datetime(2025, 1, 1),
    schedule_interval="@hourly",
    catchup=False,

) as dag:
    t1=PythonOperator(
        task_id="data_pull",
        python_callable=pull_data
    )

    t2=PythonOperator(
        task_id="audit_validation",
        python_callable=audit_rule_validation
    )

    log_audit_result = BashOperator(
    task_id="log_result",
    bash_command='echo "Audit logged at $(date)"'
)

    t4=PythonOperator(
        task_id="final_status_update",
        python_callable=final_status_update
    )

    t1 >> t2 >> log_audit_result >> t4


