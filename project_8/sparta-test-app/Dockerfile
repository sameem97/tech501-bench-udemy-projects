FROM node:latest

# Set working directory
WORKDIR /usr/src/app

# Copy your Node.js application into the container
COPY ./app/ /usr/src/app/

# Update apt and install nginx (using apt-get for scripting)
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y nginx && \
    # Update the default nginx configuration to proxy to your Node.js app
    sed -i 's|try_files $uri $uri/ =404;|proxy_pass http://localhost:3000;|g' /etc/nginx/sites-available/default && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js dependencies
RUN npm install

# Copy the startup script
COPY ./start.sh /usr/src/app/start.sh
RUN chmod +x /usr/src/app/start.sh

# Expose the port (assuming your Node.js app listens on 3000)
EXPOSE 80

# Use the startup script as the container’s entrypoint
CMD ["/usr/src/app/start.sh"]
