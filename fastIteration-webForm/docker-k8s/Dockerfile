# How to use this image:
# https://github.com/nodejs/docker-node/blob/main/README.md#how-to-use-this-image
FROM node:17

WORKDIR /usr/src/app

COPY . .

RUN chmod -R 777 debug

RUN npm install

# Expose your application's default port
EXPOSE 8081

CMD ["node", "index.js" ]

