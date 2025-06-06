#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== MERN App Deployment Script ===${NC}"

# Step 1: Deploy infrastructure with Terraform
echo -e "${GREEN}Step 1: Deploying infrastructure with Terraform${NC}"
cd infra
terraform init
terraform apply -auto-approve
echo -e "${GREEN}✓ Infrastructure deployed${NC}"

# Get ECR repository URL from Terraform output
ECR_REPO=$(terraform output -raw repository_url)
AWS_REGION=$(terraform output -raw aws_region 2>/dev/null || echo "us-east-1")
echo -e "${GREEN}✓ ECR Repository: $ECR_REPO${NC}"

# Step 2: Build and push Docker image to ECR
echo -e "${GREEN}Step 2: Building and pushing Docker image to ECR${NC}"
cd ../backend

# Login to ECR
echo -e "${YELLOW}Logging in to ECR...${NC}"
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $(echo $ECR_REPO | cut -d'/' -f1)

# Build and tag the Docker image
echo -e "${YELLOW}Building Docker image...${NC}"
docker build -t $ECR_REPO:latest -f Dockerfile.prod .

# Push the image to ECR
echo -e "${YELLOW}Pushing image to ECR...${NC}"
docker push $ECR_REPO:latest
echo -e "${GREEN}✓ Docker image pushed to ECR${NC}"

# Step 3: Update ECS service to use the new image
echo -e "${GREEN}Step 3: Updating ECS service${NC}"
cd ../infra
CLUSTER_NAME=$(terraform output -raw cluster_name 2>/dev/null || echo "${var.project_name}-cluster")
SERVICE_NAME=$(terraform output -raw service_name 2>/dev/null || echo "${var.project_name}-backend-service")

# Force new deployment of the ECS service
echo -e "${YELLOW}Forcing new deployment of ECS service...${NC}"
aws ecs update-service --cluster $CLUSTER_NAME --service $SERVICE_NAME --force-new-deployment --region $AWS_REGION
echo -e "${GREEN}✓ ECS service update initiated${NC}"

# Step 4: Deploy frontend to S3
echo -e "${GREEN}Step 4: Deploying frontend to S3${NC}"
cd ../frontend
BUCKET_NAME=$(cd ../infra && terraform output -raw frontend_bucket_name)
CLOUDFRONT_DISTRIBUTION=$(cd ../infra && terraform output -raw cloudfront_domain_name)

# Build frontend with production settings
echo -e "${YELLOW}Building frontend...${NC}"
echo "VITE_API_URL=https://$CLOUDFRONT_DISTRIBUTION/api" > .env.production
npm run build

# Upload to S3
echo -e "${YELLOW}Uploading to S3...${NC}"
aws s3 sync dist/ s3://$BUCKET_NAME/ --delete

# Invalidate CloudFront cache
echo -e "${YELLOW}Invalidating CloudFront cache...${NC}"
DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?DomainName=='$CLOUDFRONT_DISTRIBUTION'].Id" --output text)
aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*"

echo -e "${GREEN}✓ Frontend deployed${NC}"
echo -e "${YELLOW}=== Deployment Complete ===${NC}"
echo -e "Your application is available at: https://$CLOUDFRONT_DISTRIBUTION"