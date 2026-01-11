#!/bin/bash

ECR_REPO_URI="public.ecr.aws/a8f2g6a2/argo-eks-demo"

echo "Building and pushing v1 for AMD64 (EKS compatible)..."

# Login to Public ECR
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws

# Build and push v1 for AMD64 platform (EKS compatible)
docker build --platform linux/amd64 -t ${ECR_REPO_URI}:v1 .
docker push ${ECR_REPO_URI}:v1

echo "v1 (AMD64) pushed successfully: ${ECR_REPO_URI}:v1"