# Master UI
kubectl port-forward spark-pi-driver 4040:4040

# Delete Stuff
kubectl delete pods $APP_NAME
# kubectl delete services spark-pi-driver

# Logs
kubectl logs -f $APP_NAME

#
kubectl get pods
