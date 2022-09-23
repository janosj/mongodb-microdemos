# Use this if you want to see what the image looks like.
# Stricly optional.

source settings.conf

docker run -it --rm --entrypoint="" --name $APP_NAME --env CURRENT_NAMESPACE=mongodb $IMAGE_NAME bash

