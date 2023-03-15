# --name: name of the container
# -d: detached mode
# -p: map local port (left) to container port (right)
# -e: environment variable. Used for intial user, enables authentication when set.
# -v: persistent volume, map local directory (left) to container directory (right)
# last parameter is the name of the image to use

# Note on peristent volumes (-v):
# On a MacBook, this just seems to work.
# On other Linux systems, you may get Permission Denied errors. The container user has to have write permissions
# on the host data directory. An easy (but not secure) way to achieve this to open up the directory (777).
# Alternatively, change the owner of the directory to match the container user.
# But the container user is different depending on the version of the container you're using.
# To determine the container user, start the container without the -v switch, connect, and inspect the user info.
# On ubuntu images, use "id". On UBI images, inspect the "/etc/passwd" file.
#
# For example, issue the following command on your host machine:
# If using this container:                 Run this command on your host:
#   mongodb-enterprise-server:latest       sudo chown 101:65534 <host-data-dir>
#   mongodb-enterprise-server:5.0.15-ubi   sudo chown 997:996   <host-data-dir>
#
# I tested this on AWS using Amazon Linux. RHEL doesn't support Docker natively, it installs "podman" instead and the behavior is different. 

docker run --name mongodb -d -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=user -e MONGO_INITDB_ROOT_PASSWORD=pass -v $(pwd)/data:/data/db mongodb/mongodb-enterprise-server:latest

# If the name 'mongodb' is already in use, remove it:
# docker stop mongodb
# docker rm mongodb

echo 
echo "Verifying..."
docker container ls

echo
echo "To connect from local desktop, just run mongosh."
echo "This works because of the -p 27017:27017 switch."
echo "'show dbs' will come back with requires authentication (because of the -e settings)."
echo "Reconnect using 'mongosh -u user -p pass'."

echo
echo "MDB data files are stored in ./data (because of the -v switch)"
echo "Delete these files but not the directory! The directory must exist."
echo


