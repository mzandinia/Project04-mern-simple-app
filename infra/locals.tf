locals {
  # Define deployment stages to enforce order
  deployment_stages = {
    stage1 = "infrastructure" # VPC, subnets, security groups
    stage2 = "storage"        # DocumentDB, S3
    stage3 = "registry"       # ECR
    stage4 = "compute"        # ECS cluster, task definition
    stage5 = "networking"     # ALB, target groups
    stage6 = "service"        # ECS service
    stage7 = "distribution"   # CloudFront
  }
}