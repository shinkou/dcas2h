from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.providers.apache.spark.operators.spark_sql import SparkSqlOperator

with DAG(
	dag_id="test1"
	, default_args={
		"depends_on_past": False
		, "email": ["someone@somewhere.com"]
		, "email_on_failure": False
		, "email_on_retry": False
		, "retries": 1
		, "retry_delay": timedelta(minutes=3)
	}
	, description="A test DAG"
	, schedule_interval="0 0 * * *"
	, start_date=datetime(2023, 1, 1)
	, catchup=False
	, tags=["example", "test"]
) as dag:
	task1 = BashOperator(
		task_id="task1"
		, bash_command="date"
	)
	task2 = SparkSqlOperator(
		task_id="task2"
		, master="local"
		, sql="SHOW DATABASES"
	)
	task1 >> task2
