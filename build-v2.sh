#!/bin/bash

ECR_REPO_URI="public.ecr.aws/a8f2g6a2/argo-eks-demo"

echo "Building and pushing v2..."

# Login to Public ECR
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws

# Backup original and use v2 version
cp index.html index-v1-backup.html
cp index-v2.html index.html

# Build and push v2
docker build -t ${ECR_REPO_URI}:v2 .
docker push ${ECR_REPO_URI}:v2

# Restore original
mv index-v1-backup.html index.html

echo "v2 pushed successfully: ${ECR_REPO_URI}:v2"