module "network" {
  source = "./modules/network"

  project_name   = var.project_name
  environment    = var.environment
  vpc_cidr_block = var.vpc_cidr_block

  # Control subnet creation
  create_private_subnets = true  # Set to false to disable private subnets
  create_public_subnets  = false # Set to false to disable public subnets
  create_nat_gateway     = false # Set to false to disable NAT gateway

  # New parameter to create IGW without public subnets
  create_igw_without_public_subnets = true

  private_subnet_cidrs = var.private_subnet_cidrs
}