# If you want to run the app locally in a container.

# ***************************************************************
# Note, though, that the image does not include a MongoDB server.
# In Kubernetes, MongoDB is deployed separately on another node.
# To containerize the entire app, include MongoDB server in the image.
# ***************************************************************


source settings.conf

# Port mapping: map local port (left side) to container port (right side).
# The container port needs to match the port used in the node.js code.
# The local port can be anything you - 80 to avoid specifying a port.
MONGO_URL="mongodb://myserver1:27017" docker run -p 80:8081 --rm --name $APP_NAME --env CURRENT_NAMESPACE=mongodb $IMAGE_NAME:$IMAGE_TAG

echo "App running on port 80. Access app at http://localhost.
echo "Database not currently embedded."
