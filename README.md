# CI/CD Spark Pipeline
This repository contains the code used for the demo hold on ContainerDays.

It shows the creating of a machine learning pipeline using Spark, Kubernetes and Docker.

- create a CI/CD pipeline to automatically build docker images 
triggered by a tag in a github repository
- create a kubernetes cluster
- obtain kubectl and configure it appropriately
- configure RBAC roles and services for Spark components
- submit spark job


## Create a Trigger in GCP Container Registry
The GCP Container Registry is a private docker repository. 

With Google Container Builder you can create build pipelines to automatically 
create docker images from a source repository and send it to the Container Registry.

To set up the trigger, the cloudbuild.yaml file is used.

## Create a kubernetes cluster
We use Kubernetes Engine on GCP to create a kubernetes cluster. 
A cluster with 3 nodes of type `n1-standard-4` is created in the specified zone, here Frankfurt.
You have to ensure that your cluster is big enough to submit your Spark job there. 
The use the ``gcloud` command-line tool to create a container cluster. 
A container cluster is a set of Compute Engine instances called `nodes`. 
The default number if instances is 3.

Kubernetes creates a firewall for the network. 
It also creates routes for the nodes, 
so that containers running in the nodes can communicate with each other.

The Kubernetes API server does not run on your cluster nodes. 
Instead, Kubernetes Engine hosts the API server.

```
gcloud container clusters create spark-ml \
--num-nodes 3 \
--machine-type n1-standard-4 --zone europe-west3-a
```    

## Configure kubectl 

Kubernetes Engine uses the `kubectl` tool to manage resources in your cluster. 
`kubectl` is configured to use Application Default Credentials to authenticate to the cluster.

```
gcloud container clusters get-credentials spark-ml --zone europe-west3-a --project t-zoi-play18
``` 

## Getting cluster informations
```
kubectl cluster-info
```

## Using kubectl to start a proxy server and set up the k8s admin ui

This command starts a proxy to the Kubernetes API server:
```
kubectl -n kube-system describe $(kubectl -n kube-system \
get secret -n kube-system -o name | grep namespace) | grep token:
kubectl proxy  --address="0.0.0.0"  --port=8080 &
```

If the port is already in use, you can indentify the process id (first digits) and kill the process
```
ps aux | grep kubectl
kill <ID>
```

## Configure RBAC

In Kubernetes clusters with RBAC enabled, users can 
configure Kubernetes RBAC roles and service accounts used by various Spark components to access
the Kubernetes API server. 
The Spark driver pod uses a Kubernetes service account to access the Kubernetes API server to 
create and watch executor pods. The service account used by the driver pod must have the appropriate 
permission for the driver to be able to do this work.

Create a custom service account if necessary.
```
kubectl create serviceaccount spark
kubectl create clusterrolebinding spark-role --clusterrole=edit \
--serviceaccount=default:spark --namespace=default
```

## Submit Spark Jobs

Linear Regression and Random Forest Regression are already implemented in this repository.
To submit these jobs enter (from the directory where your spark is installed)

### Linear Regression
```
export APP_NAME=lr-demo
export TAG=10.0

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
```
Inspect the logs

```
kubectl logs -f lr-demo
```

Delete the pods
```
kubectl delete pods lr-demo
```

### Random Forest Regression

```
export APP_NAME=rf
export TAG=9.0

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
```
  
### Scripts

```
# Scripts to acquire and pre-process data
01_get_raw_data.sh
02_pre_precess.py

# Commands to to setup and run spark commands
03_cluster_config.sh
04_cluster_ops.sh
05_cluster_run.sh

# SBT Commands located in
06_sbt_commands.sh
```
