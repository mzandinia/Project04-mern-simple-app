# ECS Module

This module creates an ECS cluster, task definition, and service with optional auto-scaling capabilities.

## Features

- Creates an ECS Fargate cluster
- Sets up task definition with configurable CPU and memory
- Creates an ECS service with optional load balancer integration
- Configures IAM roles for task execution and task permissions
- Sets up CloudWatch logging
- Optional auto-scaling based on CPU and memory utilization
- Support for EFS volumes

## Usage

```hcl
module "ecs" {
  source = "./modules/ecs"

  project_name   = "my-project"
  environment    = "dev"
  aws_region     = "us-east-1"
  
  container_name  = "my-container"
  container_image = "my-image:latest"
  container_port  = 3000
  
  subnet_ids         = ["subnet-12345", "subnet-67890"]
  security_group_ids = ["sg-12345"]
  
  target_group_arn = module.alb.target_group_arn
  
  # Optional: Enable auto-scaling
  enable_autoscaling = true
  min_capacity       = 1
  max_capacity       = 5
  
  # Optional: Add environment variables
  container_environment = [
    {
      name  = "NODE_ENV"
      value = "production"
    }
  ]
  
  # Optional: Add secrets
  container_secrets = [
    {
      name      = "DATABASE_PASSWORD"
      valueFrom = "arn:aws:secretsmanager:region:account:secret:path"
    }
  ]
}
```