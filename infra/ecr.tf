
module "ecr" {
  source = "./modules/ecr"

  repository_name         = var.repository_name
  repository_force_delete = true

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

