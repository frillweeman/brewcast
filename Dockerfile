FROM node:18-alpine AS build-stage

# Set working directory
WORKDIR /app

# Copy the Vue app source code
COPY ./webapp/package*.json ./
COPY ./webapp/ ./

# Install dependencies and build the Vue app
RUN npm install
RUN npm run build

# Use a multi-stage build to keep the final image small
FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache ffmpeg nginx

# Copy the built Vue app from the build stage
COPY --from=build-stage /app/dist /app

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the restream script and make it executable
COPY restream.sh /restream.sh
RUN chmod +x /restream.sh

# Healthcheck to ensure the service is running
HEALTHCHECK CMD curl --fail http://localhost:8080/hls/stream.m3u8 || exit 1

# Start the restream script and Nginx
CMD ["sh", "-c", "/restream.sh & nginx -g 'daemon off;'"]
