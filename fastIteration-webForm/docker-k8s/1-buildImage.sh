source settings.conf

docker build ../code -f ./Dockerfile --no-cache -t $IMAGE_NAME

echo
echo "Docker build complete."
echo
echo "Verify: "
docker image ls | grep $APP_NAME

