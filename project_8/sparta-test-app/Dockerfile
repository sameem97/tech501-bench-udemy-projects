FROM node:latest

# Set working directory
WORKDIR /app

# Copy your Node.js application into the container
COPY ./app/ /app/

# Expose the port (assuming your Node.js app listens on 3000)
EXPOSE 3000

# Install dependencies & start app (ensures MongoDB is ready)
CMD npm install && npm start
