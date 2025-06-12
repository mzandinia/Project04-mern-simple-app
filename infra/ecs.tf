module "ecs" {
  source = "./modules/ecs"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  # Container configuration
  container_name  = "${var.project_name}-container"
  container_image = "${module.ecr.repository_url}:latest"
  container_port = 3000

  # Network configuration
  subnet_ids         = module.network.private_subnet_ids
  security_group_ids = [module.ecs_backend_sg.security_group_id]
  assign_public_ip   = false

  # Load balancer integration
  target_group_arn = module.alb.target_group_arn

  # Task configuration
  task_cpu    = 512
  task_memory = 1024

  task_role_arn      = module.ecsRole.role_arn
  execution_role_arn = module.ecsRole.role_arn

  # Environment variables
  container_environment = [
    {
      name  = "NODE_ENV"
      value = "production"
    },
    {
      name  = "PORT"
      value = "3000"
    },
    {
      name  = "DBHost"
      value = module.docdb.cluster_endpoint
    },
    {
      name  = "DBPort"
      value = "27017"
    }
  ]

  # Secrets
  container_secrets = [
    {
      name      = "DBUsername"
      valueFrom = module.docdb_username_parameter.arn
    },
    {
      name      = "DBPassword"
      valueFrom = module.docdb_password_parameter.arn
    }
  ]

  # Auto-scaling configuration
  enable_autoscaling  = true
  min_capacity        = 1
  max_capacity        = 2
  cpu_target_value    = 70
  memory_target_value = 70

  # Additional variables
  log_retention_days = 7
  desired_count      = 1

  depends_on = [
    module.vpc_endpoints_ssm,
    module.vpc_endpoints_ssm_messages,
    module.vpc_endpoints_ecr_api,
    module.vpc_endpoints_ecr_dkr,
    module.vpc_endpoints_logs
    module.ecs_backend_sg,
    module.ecsRole,
    module.docdb_username_parameter,
    module.docdb_password_parameter,
    module.alb,
    module.network,
    module.docdb,
  ]
}

