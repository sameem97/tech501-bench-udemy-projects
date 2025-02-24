# Docker

## Architecture

![architecture](images/docker-architecture.webp)

## Installation of docker desktop

- [Install link](https://docs.docker.com/desktop)

### images commands

- Docker images are a lightweight, standalone, executable package of software that includes everything needed to run an application: code, runtime, system tools, system libraries and settings.

- build image from Dockerfile:

```bash
docker build -t <image_name>
```

- list local images

```bash
docker images
```

- delete an image

```bash
docker rmi <image_name>
```

- remove all unused images

```bash
dpcler image prune
```

### dockerhub commands

- Docker Hub is a service provided by Docker for finding and sharing container images with your team. Learn more and find images at https://hub.docker.com

- login into Docker

```bash
docker login -u <username>
```

- publish an image to dockerhub

```bash
docker push <username>/<image_name>
```

- search dockerhub for an image

```bash
docker search <image_name>
```

- pull an image from dockerhub

```bash
docker pull <image_name>
```

### General commands

- start the docker daemon

```bash
docker -d
```

- get help with docker. Can also use -help on all subcommands.

```bash
docker --help
```

- display system wide information
  
```bash
docker info
```

### containers

- A container is a runtime instance of a docker image. A container will always run the same, regardless of the infrastructure. Containers isolate software from its environment and ensure that it works uniformly despite differences for instance between development and staging.

- create and run a container from an image, with a custom name

```bash
docker run --name <container_name> <image_name>
```

- run a container with and publish a container's port(s) to the host

```bash
docker run -p <host_port>:<container_port> <image_name>
```

- run a container in the background

```bash
docker run -d <image_name>
```

- start or stop an existing container

```bash
docker start|stop <container_name> (or <container-id>)
```

- remove a stopped container

```bash
docker rm <container_name>
```

- open a shell inside a running container

```bash
docker exec -it <container_name> sh
```

- fetch and follow the logs of a container

```bash
docker logs -f <container_name>
```

- inspect a running container

```bash
docker inspect <container_name> (or <container_id>)
```

- to list currently runnning containers

```bash
docker ps
```

- list all docker containers (running and stopped)

```bash
docker ps --all
```

- view resource usage stats

```bash
docker container stats
```
