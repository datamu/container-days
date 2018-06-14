FROM gcr.io/cloud-solutions-images/spark:v2.3.0

RUN rm $SPARK_HOME/jars/guava-14.0.1.jar
ADD http://central.maven.org/maven2/com/google/guava/guava/23.0/guava-23.0.jar $SPARK_HOME/jars
ADD https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-latest-hadoop2.jar $SPARK_HOME/jars

ADD data /opt/
