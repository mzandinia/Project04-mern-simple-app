data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

module "alb_sg_http" {
  source     = "./modules/security_group"
  depends_on = [module.network]

  vpc_id      = module.network.vpc_id
  name        = "${var.project_name}-alb-http-sg"
  description = "Security group for ALB"

  ingress_with_ports = [
    {
      ip_protocol    = "tcp"
      from_port      = 80
      to_port        = 80
      description    = "HTTP from CloudFront VPC Origin"
      prefix_list_id = data.aws_ec2_managed_prefix_list.cloudfront.id
    }
  ]

  egress_all_traffic = [
    {
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow all outbound traffic"
    }
  ]

  tags = {
    Name        = "${var.project_name}-alb-sg"
    Environment = var.environment
  }
}

module "alb_sg_https" {
  source     = "./modules/security_group"
  depends_on = [module.network]

  vpc_id      = module.network.vpc_id
  name        = "${var.project_name}-alb-https-sg"
  description = "Security group for ALB"

  ingress_with_ports = [
    {
      ip_protocol    = "tcp"
      from_port      = 443
      to_port        = 443
      description    = "HTTPS from CloudFront"
      prefix_list_id = data.aws_ec2_managed_prefix_list.cloudfront.id
    },
  ]

  egress_all_traffic = [
    {
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow all outbound traffic"
    }
  ]

  tags = {
    Name        = "${var.project_name}-alb-sg"
    Environment = var.environment
  }
}

module "ecs_backend_sg" {
  source     = "./modules/security_group"
  depends_on = [module.network]

  name        = "${var.project_name}-ecs-backend-sg"
  description = "Security group for ECS backend tasks"
  vpc_id      = module.network.vpc_id

  ingress_with_ports = [
    {
      from_port                    = 3000
      to_port                      = 3000
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.alb_sg_https.security_group_id
      description                  = "Allow traffic from ALB to backend"
    },
    {
      from_port                    = 3000
      to_port                      = 3000
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.alb_sg_http.security_group_id
      description                  = "Allow traffic from ALB to backend"
    }
  ]

  egress_all_traffic = [
    {
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow all outbound traffic"
    }
  ]

  tags = {
    Name        = "${var.project_name}-ecs-backend-sg"
    Environment = var.environment
  }
}

module "vpc_endpoint_sg" {
  source     = "./modules/security_group"
  depends_on = [module.network]

  name        = "${var.project_name}-vpc-endpoint-sg"
  description = "Security group for vpc endpoints"
  vpc_id      = module.network.vpc_id

  ingress_with_ports = [
    {
      from_port                    = 443
      to_port                      = 443
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.alb_sg_http.security_group_id
      description                  = "Allow traffic from ALB to VPC endpoints"
    },
    {
      from_port                    = 443
      to_port                      = 443
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.alb_sg_https.security_group_id
      description                  = "Allow traffic from ALB to VPC endpoints"
    },
    {
      from_port                    = 443
      to_port                      = 443
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.ecs_backend_sg.security_group_id
      description                  = "Allow traffic from ECS to VPC endpoints"
    }
  ]

  egress_all_traffic = [
    {
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow all outbound traffic"
    }
  ]

  tags = {
    Name        = "${var.project_name}-ecs-backend-sg"
    Environment = var.environment
  }
}

module "docdb_sg" {
  source     = "./modules/security_group"
  depends_on = [module.network]

  name        = "${var.project_name}-docdb-sg"
  description = "Security group for DocumentDB"
  vpc_id      = module.network.vpc_id

  ingress_with_ports = [
    {
      from_port                    = 27017
      to_port                      = 27017
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.ecs_backend_sg.security_group_id
      description                  = "Allow MongoDB access from ECS backend"
    }
  ]

  egress_all_traffic = [
    {
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow all outbound traffic"
    }
  ]

  tags = {
    Name        = "${var.project_name}-docdb-sg"
    Environment = var.environment
  }
}