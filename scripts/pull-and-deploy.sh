#!/bin/bash
set -e

# Check if CERTBOT_EMAIL is set
if [[ -z "$CERTBOT_EMAIL" ]]; then
  echo "CERTBOT_EMAIL is not set. WTF?!"
  exit 1
fi

# Change directory to the root of the project
cd "$(dirname "$0")/.."

echo "Pulling docker image..."
docker pull public.ecr.aws/w2o0b9g0/frillweeman/brewcast-prod:latest

echo "Restarting docker container..."
docker-compose -f docker-compose.prod.yml up -d --no-deps ffmpeg-nginx

echo "Container restarted. Done!"
