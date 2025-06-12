module "docdb" {
  source     = "./modules/docdb"
  depends_on = [module.docdb_username_parameter, module.docdb_password_parameter]

  name_prefix                   = var.project_name
  subnet_ids                    = module.network.private_subnet_ids
  security_group_ids            = [module.docdb_sg.security_group_id]
  master_username_ssm_parameter = "/docdb/master/username"
  master_password_ssm_parameter = "/docdb/master/password"

  # Optional parameters with default values
  instance_count          = 1
  instance_class          = "db.t3.medium"
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_window           = "07:00-09:00"
  maintenance_window      = "sun:05:00-sun:07:00"
  backup_retention_period = 1
  storage_encrypted       = true

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
