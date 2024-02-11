# React with Docker

A simple project based on React, which is used to demonstrate how Docker works.

## Dockerfile

Main Dockerfile is using a two-staged build process. Firstly, it installs dependencies and builds the React project based on 'node' image. Secondly, it transfers the built project to an image based on 'nginx'. Nginx is then automatically started on port 80, which should be mapped on run. To run the container use:
```sh
docker build -t erikbrudzinskis/docker-react-production .
docker run -p 8080:80 erikbrudzinskis/docker-react-production
```

## Dockerfile.dev
Dockerfile.dev is used to install dependencies and run the project on 'node' image. To support live-reload for development it does not copy a built project to the container. Instead, it should be launched with the volume mapping:
- `$(pwd):/app`
- `/app/node_modules`
The first mapping is required to map our current directory (project directory) to the container, so that the container can pick up any local changes. The second mapping is required to avoid overwriting installed node_modules by the first mapping. To run the container use:
```sh
docker build -t erikbrudzinskis/react-frontend -f Dockerfile.dev
docker run -p 3000:3000 -v /app/node_modules -v $(pwd):/app erikbrudzinskis/react-frontend
```

## docker-compose.yml
An alternative to Dockerfile.dev to avoid having to specify volumes every time we need to run the project. Runs two services:
- web - the same as building via Dockerfile.dev and running with volume mapping
- tests - the same as building via Dockerfile.dev and running with volume mapping, but with overwritten default command to `npm run test`

## CI
CI is done with Github Actions via two files:
- deploy.yaml - when there is a push to master branch, it installs, tests and deploys the project to render.com via curl to render deploy hook url.
- test.yaml - when there is a push to any branch but master or a pull request to master, it installs and tests the project.
