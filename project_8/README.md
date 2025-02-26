# Docker

- [Docker](#docker)
  - [Fundamentals](#fundamentals)
    - [VMs vs Containers](#vms-vs-containers)
    - [Azure Generalised Image vs Docker Image](#azure-generalised-image-vs-docker-image)
    - [How do containers work](#how-do-containers-work)
      - [Linux Processes and Host OS Kernel](#linux-processes-and-host-os-kernel)
      - [Container isolation mechanisms](#container-isolation-mechanisms)
      - [Linux Namespaces](#linux-namespaces)
  - [What is Docker?](#what-is-docker)
    - [Architecture](#architecture)
    - [How it works](#how-it-works)
  - [Microservices with Docker](#microservices-with-docker)
    - [What are microservices in the context of docker?](#what-are-microservices-in-the-context-of-docker)
    - [How are microservices created using docker?](#how-are-microservices-created-using-docker)
    - [Benefits of using docker for microservices](#benefits-of-using-docker-for-microservices)
  - [Multi-container orchestration with Docker Compose](#multi-container-orchestration-with-docker-compose)
    - [What is Docker Compose?](#what-is-docker-compose)
    - [How does it work?](#how-does-it-work)
    - [Why use Docker Compose?](#why-use-docker-compose)
  - [Install Docker](#install-docker)
  - [Commands](#commands)
    - [Images](#images)
    - [DockerHub](#dockerhub)
    - [General](#general)
    - [Containers](#containers)
    - [Compose](#compose)
  - [Exercises](#exercises)
    - [Run your first Container](#run-your-first-container)
    - [Run Nginx Web Server](#run-nginx-web-server)
    - [Modify nginx default page inside running container](#modify-nginx-default-page-inside-running-container)
    - [Run multiple containers](#run-multiple-containers)
    - [Create dockerfile to build custom nginx image](#create-dockerfile-to-build-custom-nginx-image)
    - [Push custom nginx image to DockerHub](#push-custom-nginx-image-to-dockerhub)
  - [deploy two tier app with docker compose](#deploy-two-tier-app-with-docker-compose)

## Fundamentals

### VMs vs Containers

- VMs:
  - includes full guest OS on top of a hypervisor.
  - emulates hardware completely, which leads to heavier resource use.
  - provide stronger isolation since each VM is a full, independent OS instance.
  - suitable for running multiple different OS environments on a single physical machine.

- Containers:
  - shares host OS kernel, making them lightweight.
  - Isolates applications at the process level.
  - start up very quickly and use fewer resources.
  - ideal for deploying microservices and quickly scaling applications.

In summary, containers are about lightweight, fast, and efficient application deployment, whereas VMs offer more robust isolation and flexibility at the cost of higher resource consumption.

### Azure Generalised Image vs Docker Image

- Azure Generalised image:
  - **Purpose**: Serves as a pre-configured template to create new virtual machines (VMs) in Azure. This image contains a full operating system along with installed software and settings.
  - **Preparation**: A generalized image is "cleaned" (for instance, using sysprep on Windows or waagent on Linux) to remove machine-specific information, making it reusable for provisioning new VMs.
  - **Isolation**: Each VM created from the image runs a full operating system on a hypervisor, providing stronger isolation but at the cost of more overhead compared to containers.
  - **Use Cases**: Best for scenarios where you need complete OS-level customization, persistent environments, or when running legacy applications that require full VM capabilities.
  - **Distribution**: Managed through Azure Compute Gallery or as custom images stored in your Azure account, ensuring integration with Azure's VM management ecosystem.

- Docker Image:
  - **Purpose**: Acts as a read-only template for creating containers. It encapsulates your application, its dependencies, and configuration in a portable format.
  - **Isolation**: Containers run on a shared host OS kernel, which makes them lightweight and fast to start. 
  - **Layered Structure**: Docker images are built in layers, allowing for efficient storage and updates.
  - **Use Cases**: Ideal for microservices, continuous deployment, and environments where rapid scaling and portability are key.
  - **Distribution**: Typically stored and distributed via container registries (e.g., Docker Hub, Azure Container Registry).

In summary, Docker images are optimized for containerised, lightweight, and portable applications, while generalised Azure images are designed for provisioning full virtual machines with dedicated operating systems and configurations tailored for a specific deployment environment.

### How do containers work

#### Linux Processes and Host OS Kernel

- Linux Processes:
  - In Linux, every running application is a process managed by the OS kernel. The kernel handles critical tasks like scheduling, memory management, and system calls (which allow processes to request services from the OS).

- Host OS Kernel:
  - The kernel is the core of your operating system. It’s responsible for interfacing with the hardware and managing resources. When you run containers, they share the host's kernel instead of having their own, which is a major factor in why containers are lightweight.

#### Container isolation mechanisms

Linux provides two main features that enable container isolation:

- **Namespaces**:
- Namespaces create isolated environments for processes. Each container gets its own namespace for:
  - Process IDs (PID): Containers have their own process numbering, so processes in one container don’t see those in another.
  - Network: Each container can have its own network stack, which means it can have its own IP address and ports.
  - Mount Points: Containers can have separate views of the filesystem, meaning changes in one container won’t affect others.

- **cgroups (Control Groups)**:
- cgroups manage and limit the resources (CPU, memory, disk I/O, etc.) that containers can use. This ensures that no single container can overwhelm the host system by consuming too many resources.

#### Linux Namespaces

- Linux namespaces are a fundamental feature in the Linux kernel that provide isolation for various system resources between different groups of processes.
- They help ensure that processes running in one namespace do not see or interfere with resources in another, which is a key aspect of how containers are isolated.

- Main types of namespaces and what they isolate:

- **Mount Namespace**:
  - Isolates the set of filesystem mount points. Processes in different mount namespaces can have different views of the filesystem hierarchy, allowing containers to have their own filesystem layout without affecting the host or other containers.

- **UTS Namespace (UNIX Time-sharing System)**:
  - Isolates hostname and domain name settings. This means that processes in a UTS namespace can have their own hostname, making it appear as if they’re running on a separate machine.

- **IPC Namespace (Interprocess Communication)**:
  - Isolates communication mechanisms like shared memory, message queues, and semaphores. Processes within an IPC namespace can only communicate with each other using these mechanisms, which enhances isolation.

- **PID Namespace (Process ID)**:
  - Isolates the process ID number space. Each PID namespace has its own set of process IDs, so a process in one namespace might see itself as having PID 1 (the init process), even though it’s not the global PID 1 on the host.

- **Network Namespace**:
  - Isolates network resources, including network interfaces, IP addresses, routing tables, and firewall rules. This lets containers have their own separate network stack, making it possible to assign unique IP addresses or manage network configurations independently.

- **User Namespace**:
  - Isolates user and group IDs. It allows a process to have a different user identity inside the namespace compared to the host. For example, a process could run as root inside a container while being mapped to an unprivileged user on the host, increasing security.

- **Cgroup Namespace**:
  - Isolates the view of cgroups, which are used to manage and limit resources (like CPU and memory) for process groups. Although not as commonly discussed as the others, it further enhances resource isolation.

- How Namespaces Work Together
  - Each namespace type addresses a specific aspect of system resources, and when combined, they allow containers to run isolated environments on a single host.
  - This isolation ensures that processes within a container are unaware of processes, network configurations, or filesystem structures in other containers or on the host system.
  - Namespaces, when used alongside control groups (cgroups), provide both isolation and resource management, which is why containers are both lightweight and secure.

- Practical Implications
  - **Lightweight Isolation**: Because namespaces share the host’s kernel while isolating only the necessary components, containers start up quickly and use fewer resources compared to full virtual machines.
  - **Security and Stability**: Isolation minimises the risk that processes in one container can affect those in another, thereby enhancing security and system stability.

## What is Docker?

- platform that packages applications and their dependencies into standardised units called containers
- containers run consistently across different environments, solely requires the installation of docker to run the container exactly the same in test/prod as on your local machine.
- container process is isolated from the host machine (see fundamentals above).
- solves the problem of "it works on my machine!"

### Architecture

![docker architecture](images/docker-architecture.webp)

### How it works

- **client server** model
- **client**: handles user commands, sneds request to dameon using REST API.
- **daemon (dockerd)**: background service that does the actual work of building, running and managing containers. Listents to API requests from the client and handles them e.g. pull/create image, start/stop container, network/volume management.
- **dockerfile**: script (can think of it as a recipe) to create docker image. Need to specify environment, dependencies, and commands needed to run an application inside a container.
- **docker images**: read only blueprint to create containers. Created using dockerfile and stored in dockerhub.
- **docker container**: running instance of an image.
- **docker registry**: storage location for docker images. DockerHub is default public registry, can push and pull images from there. But also can use private registries e.g. Azure Container Registry.
- **docker volumes**: persistent storage mechanism for containers, used to store data that should survive container restars.
- **docker networks**: manages how containers communicate with each other and the outside world.

## Microservices with Docker

### What are microservices in the context of docker?

- Microservices is an architectural style where an application is broken down into smaller, independent services that communicate with each other. Each microservice is responsible for a specific business function and runs as a separate process.

- Docker plays a key role in microservices by allowing each microservice to be packaged as a lightweight container. These containers can run independently, communicate via APIs, and be deployed across different environments seamlessly.

- See Spotify success story. Migrated from monolithic arhictecture to microservices using Docker.

### How are microservices created using docker?

1. Design the Microservices

   - Identify different business functionalities that can be separated.
   - Define APIs or message queues for communication between services.

2. Develop Each Microservice

   - Use different programming languages and frameworks based on requirements.
   - Implement RESTful APIs, gRPC, or event-driven communication.

3. Containerise Each Microservice

   - Write a Dockerfile for each microservice.
   - Build a Docker image for each microservice using:

    ```bash
    docker build -t microservice-name .
    ```

4. Define Dependencies and Networking

   - Use Docker Compose to manage multiple microservices.
   - Define services in a docker-compose.yml file:

    ```yaml
    version: '3'
    services:
    service1:
        image: service1-image
        ports:
        - "5000:5000"
        depends_on:
        - database
    database:
        image: postgres
        environment:
        POSTGRES_USER: user
        POSTGRES_PASSWORD: password
    ```

5. Deploy and Scale

   - Run the microservices using Docker Compose:

    ```bash
    docker-compose up -d
    ```

   - Use Kubernetes for orchestration if scaling across multiple nodes.

### Benefits of using docker for microservices

1. **Isolation** – Each microservice runs in its own container, avoiding dependency conflicts.

2. **Portability** – Docker containers can run across different environments without changes.

3. **Scalability** – Microservices can be scaled independently based on demand.

4. **Fault Tolerance** – If one microservice fails, others continue running.

5. **Faster Deployment** – Containers can be started and stopped quickly.

6. **Efficient Resource Utilisation** – Containers share the same OS kernel, reducing overhead.

## Multi-container orchestration with Docker Compose

### What is Docker Compose?

- tool to define and run multi-container docker applications.
- uses yml config file to manage services, networks, and volumes.
- can orchestrate services together e.g. start, stop, rebuild etc.

### How does it work?

- definitions in yml file
- potential .env file for environment variable configuration
- compose CLI processes commands like `up`, `down`, `build`. And parses config files and validates syntax.
- orchestration with service management, resource management and service discovery.

### Why use Docker Compose?

- simplify configuration: define entire app stack in single yml file.
- reproducable environments: create consistent dev, test and prod environments.
- single command management: start, stop and rebuild services with single command.
- auto container networking: built-in service discovery between containers.
- env variable management: easy configuration across different environments.
- volume management: persist data storage across container restarts.

## Install Docker

- Docker desktop: [Install](https://docs.docker.com/desktop)
- includes Docker Engine and Docker Compose CLI.

## Commands

### Images

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

### DockerHub

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

### General

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

### Containers

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

### Compose

- Start application in detached mode

```bash
docker compose up -d
```

- check running services.

```bash
docker compose ps
```

- check real-time logs.

```bash
docker compose logs -f
```

- stop application

```bash
docker compose down
```

- list images

```bash
docker compose images
```

## Exercises

### Run your first Container

```bash
docker run hello-world
```

- pulls hello-world image from Docker Hub if not found locally
- uses the image to create a running container

### Run Nginx Web Server

1. Pull lates nginx image.

    ```bash
    docker pull nginx
    ```

2. Run nginx container

    ```bash
    docker run -d -p 80:80 nginx
    ```

   - `-d`: detached mode
   - `-p 80:80`: map host port 80 to container port 80

3. Access nginx webpage.

    `http://localhost`

4. Stop the container.

    ```bash
    docker stop <container_id>
    ```

   - confirm container has stopped with `docker ps`.

### Modify nginx default page inside running container

- many images including nginx built on ubuntu or some form of lightweight linux as a base so can run interactive terminal inside the container as below.

```bash
docker exec -it <container_id> bash
```

- edit nginx page:

```bash
nano /usr/share/nginx/html/index.html
```

- this should update nginx home page immediately.

### Run multiple containers

- run first nginx container as before.

```bash
docker run -d -p 80:80 nginx
```

- try running second container on same port.

```bash
docker run -d -p 80:80 daraymonsta/nginx-257:dreamteam
```

- results in error: port already allocated.
- try run on a different host port.

```bash
docker run -d -p 90:80 daraymonsta/nginx-257:dreamteam
```

- should work now!

### Create dockerfile to build custom nginx image

- project directory: custom_nginx/
- create custom `index.html`:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Custom Nginx</title>
</head>
<body>
    <h1>Welcome to Custom Nginx!</h1>
</body>
</html>
```

- create `DockerFile`.

```dockerfile
FROM nginx
COPY index.html /usr/share/nginx/html/
EXPOSE 80
```

- build image.

```bash
docker build -t custom-nginx:v1 .
```

- run container.

```bash
docker run -d -p 80:80 custom-nginx:v1
```

### Push custom nginx image to DockerHub

- need to login to dockerhub.

```bash
docker login
```

- after authentication, need to tag the image.

```bash
docker tag custom-nginx username/custom-nginx
```

- push to dockerhub.

```bash
docker push username/custom-nginx
```

- assuming public visbility of the image, now anyone can run it on their machine!

```bash
docker run -d -p host_port:container_port username/custom-nginx
```

## deploy two tier app with docker compose

- will create separate services for nginx, app and mongodb.
- will also define volume for mongodb for persistent storage.

- dockerfile:

```dockerfile
FROM node:latest

# Set working directory
WORKDIR /app

# Copy your Node.js application into the container
COPY ./app/ /app/

# Expose the port (assuming your Node.js app listens on 3000)
EXPOSE 3000

# Install dependencies & start app (ensures MongoDB is ready)
CMD npm install && npm start
```

- docker-compose.yml

```yaml
services:
  nginx:
    image: nginx:latest
    ports:
      - "80:80"  # map port 80 (host) to port 80 (container) for http traffic
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro  # Use custom nginx config (bind mount, read only)
    container_name: nginx-reverse-proxy
    depends_on:
      - app
  app:
    build:
      context: .
    image: sparta-test-app
    container_name: sparta-test-app
    ports:
      - "3000:3000"  # Expose Node.js directly (for debugging)
    depends_on:
      mongo_db:
        condition: service_healthy  # Ensure MongoDB is fully ready before app starts
    environment:
      - DB_HOST=mongodb://mongo_db:27017/posts
  mongo_db:
    image: mongo:7.0
    container_name: mongodb
    restart: always
    volumes:
      - mongo_db_data:/data/db  # Persist MongoDB data
    healthcheck:  # Add health check to ensure MongoDB is fully ready before app starts
      test: ["CMD", "mongosh", "--eval", "db.runCommand({ ping: 1 })"] # Check if MongoDB is responsive
      interval: 10s # Check every 10 seconds
      retries: 5 # Retry 5 times before failing
      start_period: 10s # Wait 10 seconds before starting health checks
  
volumes:
  mongo_db_data:
```

- nginx.conf

```nginx
events {}

http {
    server {
        listen 80;

        location / {
            proxy_pass http://app:3000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
```

- note:
  - uses default bridge network so containers can communicate with each other using service name
  - `depends on` ensures database *starts* before app, however using healthcheck to ensure database is healthy (ping) before app is started.
  - have separate nginx and app compared to previous two-tier deployments hence `proxy_pass` forwarding to app rather than localhost. Typically one container equals one service.
  - mongodb and nginx images pulled from dockerhub, whereas app is building an image from the dockerfile. If dockerfile is changed and `docker compose up` is run, then will create new image else will use existing image.
  - setup tested and working on local machine i.e. can access app and posts page. Need to test on EC2 instance.
