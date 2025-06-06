# MERN Simple App on AWS ECS

This project deploys a MERN (MongoDB, Express, React, Node.js) application on AWS using ECS, CloudFront, and DocumentDB.

## Architecture

- **Frontend**: React application hosted in S3 and served through CloudFront
- **Backend**: Node.js/Express API running on ECS Fargate (private)
- **Database**: DocumentDB cluster in private subnets
- **CDN**: CloudFront distribution for frontend assets and API proxy

## GitHub Actions CI/CD

This project uses GitHub Actions for continuous deployment with a smart workflow that:

1. **First-time deployment**: Deploys infrastructure first, then builds and deploys application
2. **Subsequent deployments**: Only builds and deploys application components without recreating infrastructure

### Required GitHub Secrets

- `AWS_ROLE_ARN`: ARN of the IAM role with permissions to deploy resources
- `TF_STATE_BUCKET`: S3 bucket name for Terraform state
- `DOCDB_USERNAME`: DocumentDB master username
- `DOCDB_PASSWORD`: DocumentDB master password
- `ECR_REPO_NAME`: Name of the ECR repository (must match what's in Terraform)
- `DEPLOYMENT_SECRET_ARN`: ARN of a Secrets Manager secret to store deployment details
- `ECS_CLUSTER_NAME`: Name of the ECS cluster (only needed after first deployment)
- `ECS_SERVICE_NAME`: Name of the ECS service (only needed after first deployment)
- `S3_BUCKET_NAME`: Name of the S3 bucket (only needed after first deployment)
- `CLOUDFRONT_DOMAIN`: CloudFront domain name (only needed after first deployment)

### Deployment Options

The workflow can be triggered:
- Automatically on push to main branch
- Manually with option to redeploy infrastructure

## Manual Deployment

If you need to deploy manually:

1. **Deploy Infrastructure**:
   ```bash
   cd infra
   terraform init -backend-config="bucket=YOUR_STATE_BUCKET" -backend-config="key=mern-app/terraform.tfstate" -backend-config="region=us-east-1"
   terraform apply -var="docdb_master_username=admin" -var="docdb_master_password=your_password"
   ```

2. **Build and Push Backend Docker Image**:
   ```bash
   cd backend
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(terraform output -raw repository_url | cut -d'/' -f1)
   docker build -t $(terraform output -raw repository_url):latest -f Dockerfile.prod .
   docker push $(terraform output -raw repository_url):latest
   ```

3. **Update ECS Service**:
   ```bash
   aws ecs update-service --cluster $(terraform output -raw cluster_name) --service $(terraform output -raw service_name) --force-new-deployment
   ```

4. **Deploy Frontend**:
   ```bash
   cd frontend
   echo "VITE_API_URL=https://$(terraform output -raw cloudfront_domain_name)/api" > .env.production
   npm run build
   aws s3 sync dist/ s3://$(terraform output -raw frontend_bucket_name)/ --delete
   ```

## First-Time Setup

For the first deployment:

1. Create an S3 bucket for Terraform state
2. Create a Secrets Manager secret to store deployment details
3. Set up the required GitHub secrets
4. Run the workflow with "Deploy infrastructure" set to "yes"

After the first successful deployment, the workflow will automatically store resource details in Secrets Manager for future deployments.