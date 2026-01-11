#!/bin/bash

# Set your ECR repository details
AWS_REGION="us-west-2"  # Change to your region
ECR_REPO_NAME="argocd-demo"  # Change to your ECR repo name
AWS_ACCOUNT_ID="123456789012"  # Change to your AWS account ID

ECR_REPO_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}"

echo "Building and pushing ArgoCD demo images..."

# Login to ECR
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO_URI}

# Build and push v1
echo "Building v1..."
docker build -t ${ECR_REPO_URI}:v1 .
docker push ${ECR_REPO_URI}:v1

# Create v2 version with updated HTML
echo "Creating v2 version..."
sed -i.bak 's/Version: v1/Version: v2/g' index.html
sed -i.bak 's/background-color: #f0f0f0/background-color: #e8f4fd/g' index.html

# Build and push v2
echo "Building v2..."
docker build -t ${ECR_REPO_URI}:v2 .
docker push ${ECR_REPO_URI}:v2

# Restore original v1 file
mv index.html.bak index.html

echo "Both versions pushed successfully!"
echo "v1: ${ECR_REPO_URI}:v1"
echo "v2: ${ECR_REPO_URI}:v2"
echo ""
echo "Update your deployment.yml with:"
echo "image: ${ECR_REPO_URI}:v1"