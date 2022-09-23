source settings.conf

echo
echo "To proceed further, this demo requires a running Kubernetes cluster with the MongoDB Kubernetes Operator, Ops Manager, and a 3-node MongoDB replica set to function as the backend database for this application (you could use a smaller footprint if you wanted to). Scripts to deploy such an environment can be found here: https://github.com/janosj/mongodb-kubernetes-operator."

echo
echo "This project expects the Node app to be running on Port $NODE_PORT. A service will be created to access it externally on Port 80."
echo
echo "It expects a MongoDB database to be accessible at $MDB_URI."
echo
echo "Adjust the settings.conf file as necessary."
echo


