module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  environment       = var.environment
  internal          = true
  security_group_id = [module.alb_sg_http.security_group_id, module.alb_sg_https.security_group_id]
  subnet_ids        = module.network.private_subnet_ids
  vpc_id            = module.network.vpc_id

  # Target group configuration
  target_port     = 3000
  target_protocol = "HTTP"
  target_type     = "ip"

  # Health check configuration
  health_check_enabled             = true
  health_check_interval            = 30
  health_check_path                = "/health"
  health_check_port                = "traffic-port"
  health_check_healthy_threshold   = 3
  health_check_unhealthy_threshold = 3
  health_check_timeout             = 5
  health_check_protocol            = "HTTP"
  health_check_matcher             = "200"

  # HTTPS configuration
  enable_https = false
  # ssl_policy   = "ELBSecurityPolicy-2016-08"

  tags = {
    Project = var.project_name
  }
}