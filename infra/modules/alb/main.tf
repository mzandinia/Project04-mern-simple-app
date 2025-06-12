# Application Load Balancer
resource "aws_lb" "this" {
  name               = "${var.project_name}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_group_id  # This should now accept a list
  subnets            = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(
    {
      Name        = "${var.project_name}-alb"
      Environment = var.environment
    },
    var.tags
  )
}

# Target Group
resource "aws_lb_target_group" "this" {
  name        = "${var.project_name}-tg"
  port        = var.target_port
  protocol    = var.target_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    enabled             = var.health_check_enabled
    interval            = var.health_check_interval
    path                = var.health_check_path
    port                = var.health_check_port
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
    protocol            = var.health_check_protocol
    matcher             = var.health_check_matcher
  }

  tags = merge(
    {
      Name        = "${var.project_name}-tg"
      Environment = var.environment
    },
    var.tags
  )
}

# HTTP Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# HTTPS Listener with certificate
resource "aws_lb_listener" "https" {
  count = var.enable_https ? 1 : 0
  
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn != "" ? var.certificate_arn : aws_acm_certificate.self_signed[0].arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# Self-signed certificate (only created if no certificate ARN is provided and HTTPS is enabled)
resource "aws_acm_certificate" "self_signed" {
  count = var.enable_https && var.certificate_arn == "" ? 1 : 0
  
  private_key      = tls_private_key.self_signed[0].private_key_pem
  certificate_body = tls_self_signed_cert.self_signed[0].cert_pem

  lifecycle {
    create_before_destroy = true
  }
}

resource "tls_private_key" "self_signed" {
  count = var.enable_https && var.certificate_arn == "" ? 1 : 0
  
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "self_signed" {
  count = var.enable_https && var.certificate_arn == "" ? 1 : 0
  
  private_key_pem = tls_private_key.self_signed[0].private_key_pem

  subject {
    common_name  = var.certificate_common_name
    organization = var.certificate_organization
  }

  validity_period_hours = var.certificate_validity_period_hours

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}
