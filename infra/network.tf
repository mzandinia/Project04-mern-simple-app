module "network" {
  source = "./modules/network"

  project_name   = var.project_name
  environment    = var.environment
  vpc_cidr_block = var.vpc_cidr_block

  # Control subnet creation
  create_public_subnets  = false # Keep this false to disable public subnets
  create_private_subnets = true  # Keep this true for private subnets
  create_nat_gateway     = false # Keep this false to disable NAT gateway
  
  # Create IGW without public subnets
  create_igw_without_public_subnets = true

  private_subnet_cidrs = var.private_subnet_cidrs
}