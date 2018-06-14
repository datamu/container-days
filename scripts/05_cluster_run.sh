
# Spark pi Job with jar on GCP
bin/spark-submit \
 --master k8s://http://127.0.0.1:8080 \
 --deploy-mode cluster \
 --name spark-pi \
 --class org.apache.spark.examples.SparkPi \
 --conf spark.executor.instances=3 \
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
 local:///opt/spark/examples/jars/spark-examples_2.11-2.3.0.jar 100

# Test Scala Jar
export APP_NAME=spark-demo
export TAG=4.0

bin/spark-submit \
 --master k8s://http://127.0.0.1:8080 \
 --deploy-mode cluster \
 --name $APP_NAME \
 --class com.zoi.xgb.DemoTest \
 --conf spark.executor.instances=3 \
 --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
 --conf spark.kubernetes.container.image=gcr.io/t-zoi-play18/spark-k8:$TAG \
 --conf spark.kubernetes.driver.pod.name=$APP_NAME \
  local:///opt/spark/jars/xgboost_2.11-1.0.jar /opt/smart_meter.csv

kubectl delete pods $APP_NAME

# Submit Linear Regression
export APP_NAME=lr-demo
export TAG=1.0

bin/spark-submit \
 --master k8s://http://127.0.0.1:8080 \
 --deploy-mode cluster \
 --name $APP_NAME \
 --class com.zoi.xgb.DemoLR \
 --conf spark.executor.instances=3 \
 --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
 --conf spark.kubernetes.container.image=gcr.io/t-zoi-play18/spark-k8:$TAG \
 --conf spark.kubernetes.driver.pod.name=$APP_NAME \
  local:///opt/spark/jars/zoi-demo_2.11-1.0.jar /opt/smart_meter.csv

kubectl delete pods $APP_NAME
kubectl logs -f lr-demo

test rmse: 0.5352519473911752

# Submit Random Forest
export APP_NAME=rf
export TAG=1.0

bin/spark-submit \
 --master k8s://http://127.0.0.1:8080 \
 --deploy-mode cluster \
 --name $APP_NAME \
 --class com.zoi.xgb.DemoRF \
 --conf spark.executor.instances=3 \
 --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
 --conf spark.kubernetes.container.image=gcr.io/t-zoi-play18/spark-k8:$TAG \
 --conf spark.kubernetes.driver.pod.name=$APP_NAME \
  local:///opt/spark/jars/zoi-demo_2.11-1.0.jar /opt/smart_meter.csv

kubectl delete pods $APP_NAME
kubectl logs -f rf

# 0.4162156312857902