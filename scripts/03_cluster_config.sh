
gcloud container clusters create spark-ml \
--num-nodes 3 \
--machine-type n1-standard-4 --zone europe-west3-a

# Get Creds
gcloud container clusters get-credentials spark-ml --zone europe-west3-a --project t-zoi-play18
kubectl cluster-info

# K8 Admin UI
kubectl -n kube-system describe $(kubectl -n kube-system \
get secret -n kube-system -o name | grep namespace) | grep token:
kubectl proxy  --address="0.0.0.0"  --port=8080 &

# Configure RBAC
kubectl create serviceaccount spark
kubectl create clusterrolebinding spark-role --clusterrole=edit --serviceaccount=default:spark --namespace=default
