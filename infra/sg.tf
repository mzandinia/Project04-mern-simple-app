# Get the first security group from DocumentDB cluster
data "aws_security_group" "docdb" {
  id = tolist(aws_docdb_cluster.default.vpc_security_group_ids)[0]
}

# Security Group for App Runner to DocumentDB communication
resource "aws_security_group" "apprunner_docdb" {
  name        = "apprunner-docdb-sg"
  description = "Security group for App Runner to DocumentDB communication"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = tolist(aws_docdb_cluster.default.vpc_security_group_ids)
    description     = "Allow DocumentDB access from App Runner"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "apprunner-docdb-sg"
  }
}

# Update DocumentDB security group to allow access from App Runner
resource "aws_security_group_rule" "docdb_from_apprunner" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.apprunner_docdb.id
  security_group_id        = tolist(aws_docdb_cluster.default.vpc_security_group_ids)[0]
  description              = "Allow DocumentDB access from App Runner"
}