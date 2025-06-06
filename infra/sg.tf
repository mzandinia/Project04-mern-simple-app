# # Security Groups
# resource "aws_security_group" "alb" {
#   name        = "${var.project_name}-alb-sg"
#   description = "Security group for ALB"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow HTTP from CloudFront"
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow HTTPS from CloudFront"
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow all outbound traffic"
#   }

#   tags = {
#     Name        = "${var.project_name}-alb-sg"
#     Environment = var.environment
#   }
# }

# resource "aws_security_group" "ecs_backend" {
#   name        = "${var.project_name}-ecs-backend-sg"
#   description = "Security group for ECS backend tasks"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     from_port       = 3000
#     to_port         = 3000
#     protocol        = "tcp"
#     security_groups = [aws_security_group.alb.id]
#     description     = "Allow traffic from ALB to backend"
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow all outbound traffic"
#   }

#   tags = {
#     Name        = "${var.project_name}-ecs-backend-sg"
#     Environment = var.environment
#   }
# }

# resource "aws_security_group" "docdb" {
#   name        = "${var.project_name}-docdb-sg"
#   description = "Security group for DocumentDB"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     from_port       = 27017
#     to_port         = 27017
#     protocol        = "tcp"
#     security_groups = [aws_security_group.ecs_backend.id]
#     description     = "Allow MongoDB access from ECS backend"
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow all outbound traffic"
#   }

#   tags = {
#     Name        = "${var.project_name}-docdb-sg"
#     Environment = var.environment
#   }
# }