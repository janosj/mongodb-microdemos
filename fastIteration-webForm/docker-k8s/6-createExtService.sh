source settings.conf

echo "Deploying external service for node app ..."
cat <<EOF | kubectl apply -n mongodb -f -
---
apiVersion: v1
kind: Service
metadata:
  name: $APP_NAME-ext
spec:
  selector:
    app: $APP_NAME
  ports:
    - port: 80
      targetPort: 8081
  type: LoadBalancer
EOF

# service will be in pending state for several seconds
sleep 5

echo
kubectl get service | grep $APP_NAME
echo

echo "Access the app with a browser at the above URL (http). NOTE: it can take several seconds before it registers with DNS."


# To DELETE:
# kubectl delete service $APP_NAME-ext

