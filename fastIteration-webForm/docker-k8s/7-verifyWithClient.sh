source settings.conf

echo
echo "Connects to a Mongo client container (assuming you "
echo "deployed one and named it 'mdb-client'), allowing you "
echo "to verify that the form data is making it to the target database."
echo
echo "The app's DB connect string is available from Ops Manager,"
echo "but it is determined by the database and service names "
echo "specified in the deployment yaml files. This is the same URL"
echo "that the Node app is configured to use."
echo
echo "Use mongosh instead of mongo:"
echo "mongosh '$MDB_URI'"
echo

kubectl exec -it -n mongodb mdb-client -- /bin/bash
