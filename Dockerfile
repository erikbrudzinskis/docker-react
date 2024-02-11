# Dockerfile can have multi-step process with several initial images
# Image 1 - used to build the application. We tag it as 'builder'. All commands below will be executed as part of the 'builder' phase.
FROM node:21-alpine AS builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Image 2 - used to run nginx with our static content. As soon as Docker encounters next FROM block, it considers previous phase to be done.
# Apart from what we will explicitly copy, everything else created during the previous phase will be removed.
FROM nginx
# By default, EXPOSE does not do anything apart from letting know other developers that port 80 should be exposed for this application to work.
# However, some external services (such as ElasticBeanstalk) will pick this when reading Dockerfile and expose listed port.
EXPOSE 80
# --from=builder - we don't have access to files generated in the previous step, unless we explicitly specify that we want to copy from there.
# /usr/share/nginx/html - default directory for nginx to serve content from
COPY --from=builder  /app/build /usr/share/nginx/html
# We don't have to specify CMD, because nginx already starts up by default