# Master UI
kubectl port-forward spark-pi-driver 4040:4040

# Delete Stuff
kubectl delete pods spark-pi-driver
# kubectl delete services spark-pi-driver

# Logs
kubectl logs -f spark-pi-driver

#
kubectl get pods
