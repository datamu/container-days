
# Spark pi Job with jar on GCP
bin/spark-submit \
 --master k8s://http://127.0.0.1:8080 \
 --deploy-mode cluster \
 --name spark-pi \
 --class org.apache.spark.examples.SparkPi \
 --conf spark.executor.instances=5 \
 --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
 --conf spark.kubernetes.container.image=gcr.io/t-zoi-play18/spark-k8:11 \
 --conf spark.kubernetes.driver.pod.name=spark-pi-driver \
 gs://datateam_spark/spark-examples_2.11-2.3.0.jar 10

# Spark local
bin/spark-submit \
 --master k8s://http://127.0.0.1:8080 \
 --deploy-mode cluster \
 --name spark-pi \
 --class org.apache.spark.examples.SparkPi \
 --conf spark.executor.instances=5 \
 --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
 --conf spark.kubernetes.container.image=gcr.io/t-zoi-play18/spark-k8:11 \
 --conf spark.kubernetes.driver.pod.name=spark-pi-driver \
 local:///opt/spark/examples/jars/spark-examples_2.11-2.3.0.jar 10

# Submit Decision Tree
# Submit XG Boost
