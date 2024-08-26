#!/bin/bash
set -e

# Change directory to the root of the project
cd "$(dirname "$0")/.."

echo "Building docker image..."
docker-compose -f docker-compose.dev.yml build

echo "Logging into AWS..."
source awsume personal
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/w2o0b9g0

echo "Pushing docker image..."
docker push public.ecr.aws/w2o0b9g0/frillweeman/brewcast-prod:latest

echo "Image pushed to ECR. Done!"
