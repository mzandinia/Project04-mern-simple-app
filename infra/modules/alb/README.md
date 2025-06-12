# ALB Module

This module creates an Application Load Balancer (ALB) with HTTP and HTTPS listeners, a target group, and optionally a self-signed certificate for HTTPS.

## Features

- Creates an internal or internet-facing ALB
- Configures a target group with customizable health checks
- Sets up HTTP listener
- Optionally sets up HTTPS listener with either a provided certificate or a self-signed one
- Configurable security groups, subnets, and other parameters

## Usage

```hcl
module "alb" {
  source = "./modules/alb"

  project_name    = "my-project"
  environment     = "dev"
  internal        = true
  security_group_id = module.alb_sg.security_group_id
  subnet_ids      = module.network.private_subnet_ids
  vpc_id          = module.network.vpc_id

  # Target group configuration
  target_port     = 3000
  target_protocol = "HTTP"
  target_type     = "ip"

  # Health check configuration
  health_check_path = "/health"

  # HTTPS configuration
  enable_https    = true
  # certificate_arn = "arn:aws:acm:region:account-id:certificate/certificate-id" # Uncomment to use an existing certificate
}
```