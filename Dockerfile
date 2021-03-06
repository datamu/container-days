FROM gcr.io/cloud-solutions-images/spark:v2.3.0

RUN rm $SPARK_HOME/jars/guava-14.0.1.jar
ADD http://central.maven.org/maven2/com/google/guava/guava/23.0/guava-23.0.jar $SPARK_HOME/jars
ADD https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-latest-hadoop2.jar $SPARK_HOME/jars

# XGBoost jars
ADD https://github.com/krishnakalyan3/container-days/blob/master/jars/xgboost4j-0.80-SNAPSHOT.jar?raw=true $SPARK_HOME/jars
ADD https://github.com/krishnakalyan3/container-days/blob/master/jars/xgboost4j-spark-0.80-SNAPSHOT.jar?raw=true $SPARK_HOME/jars

# Download data to the container
ADD https://raw.githubusercontent.com/datamu/container-days/master/data/smart_meter.csv /opt/

# Jar from the Build Process
ADD target/scala-2.11 $SPARK_HOME/jars
