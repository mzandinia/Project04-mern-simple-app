# Create a new module for VPC endpoints
module "vpc_endpoints_ssm" {
  source = "./modules/vpc_endpoints"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  private_subnet_ids    = module.network.private_subnet_ids
  security_group_ids    = [module.vpc_endpoint_sg.security_group_id]
  endpoint_service_name = "ssm"
  endpoint_type         = "Interface"
  private_dns_enabled   = true
}

module "vpc_endpoints_ssm_messages" {
  source = "./modules/vpc_endpoints"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  private_subnet_ids    = module.network.private_subnet_ids
  security_group_ids    = [module.vpc_endpoint_sg.security_group_id]
  endpoint_service_name = "ssmmessages"
  endpoint_type         = "Interface"
  private_dns_enabled   = true
}

module "vpc_endpoints_ecr_api" {
  source = "./modules/vpc_endpoints"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  private_subnet_ids    = module.network.private_subnet_ids
  security_group_ids    = [module.vpc_endpoint_sg.security_group_id]
  endpoint_service_name = "ecr.api"
  endpoint_type         = "Interface"
  private_dns_enabled   = true
}

module "vpc_endpoints_ecr_dkr" {
  source = "./modules/vpc_endpoints"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  private_subnet_ids    = module.network.private_subnet_ids
  security_group_ids    = [module.vpc_endpoint_sg.security_group_id]
  endpoint_service_name = "ecr.dkr"
  endpoint_type         = "Interface"
  private_dns_enabled   = true
}

module "vpc_endpoints_logs" {
  source = "./modules/vpc_endpoints"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  private_subnet_ids    = module.network.private_subnet_ids
  security_group_ids    = [module.vpc_endpoint_sg.security_group_id]
  endpoint_service_name = "logs"
  endpoint_type         = "Interface"
  private_dns_enabled   = true
}

module "vpc_endpoints_s3" {
  source = "./modules/vpc_endpoints"

  project_name            = var.project_name
  environment             = var.environment
  vpc_id                  = module.network.vpc_id
  private_route_table_ids = [module.network.private_route_table_id]
  endpoint_service_name   = "s3"
  endpoint_type           = "Gateway"
  private_dns_enabled     = false
}