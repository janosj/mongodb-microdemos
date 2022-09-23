source settings.conf

echo "Deploying Node.js app to Kubernetes ..."
cat <<EOF | kubectl apply -n mongodb -f -
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $APP_NAME
spec:
  replicas: 1
  selector:
    matchLabels:
      app: $APP_NAME
  template:
    metadata:
      labels:
        app: $APP_NAME
    spec:
      containers:
        - name: app
          image: $IMAGE_NAME
          ports:
            - containerPort: 8081
          env:
            - name: URI
              value: $MDB_URI
          imagePullPolicy: Always
EOF

echo
echo "To VERIFY: kubectl get deployment $APP_NAME -n mongodb"
echo "To DELETE: kubectl delete deployment $APP_NAME -n mongodb"
echo
echo "Status:"
kubectl get deployment $APP_NAME -n mongodb -w

