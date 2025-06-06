# # Application Load Balancer
# resource "aws_lb" "backend" {
#   name               = "${var.project_name}-alb"
#   internal           = true
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb.id]
#   subnets            = aws_subnet.private[*].id

#   enable_deletion_protection = false

#   tags = {
#     Name        = "${var.project_name}-alb"
#     Environment = var.environment
#   }
# }

# # Target Group
# resource "aws_lb_target_group" "backend" {
#   name        = "${var.project_name}-tg"
#   port        = 3000
#   protocol    = "HTTP"
#   vpc_id      = aws_vpc.main.id
#   target_type = "ip"

#   health_check {
#     enabled             = true
#     interval            = 30
#     path                = "/health"
#     port                = "traffic-port"
#     healthy_threshold   = 3
#     unhealthy_threshold = 3
#     timeout             = 5
#     protocol            = "HTTP"
#     matcher             = "200"
#   }

#   tags = {
#     Name        = "${var.project_name}-tg"
#     Environment = var.environment
#   }
# }

# # HTTP Listener
# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.backend.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.backend.arn
#   }
# }

# # HTTPS Listener (using self-signed certificate for demo)
# resource "aws_acm_certificate" "self_signed" {
#   private_key      = tls_private_key.example.private_key_pem
#   certificate_body = tls_self_signed_cert.example.cert_pem

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "tls_private_key" "example" {
#   algorithm = "RSA"
# }

# resource "tls_self_signed_cert" "example" {
#   private_key_pem = tls_private_key.example.private_key_pem

#   subject {
#     common_name  = "example.com"
#     organization = "Example Organization"
#   }

#   validity_period_hours = 12

#   allowed_uses = [
#     "key_encipherment",
#     "digital_signature",
#     "server_auth",
#   ]
# }

# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.backend.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = aws_acm_certificate.self_signed.arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.backend.arn
#   }
# }