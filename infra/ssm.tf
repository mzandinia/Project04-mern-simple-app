module "docdb_username_parameter" {
  source = "./modules/ssm_parameter"

  name        = "/docdb/master/username"
  description = "DocumentDB master username"
  type        = "SecureString"
  value       = var.docdb_master_username

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

module "docdb_password_parameter" {
  source = "./modules/ssm_parameter"

  name        = "/docdb/master/password"
  description = "DocumentDB master password"
  type        = "SecureString"
  value       = var.docdb_master_password

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
