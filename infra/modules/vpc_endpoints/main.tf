data "aws_region" "current" {}

# SSM Endpoints
resource "aws_vpc_endpoint" "this" {

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${var.endpoint_service_name}"
  vpc_endpoint_type   = var.endpoint_type
  subnet_ids          = var.endpoint_type == "Interface" ? var.private_subnet_ids : null
  route_table_ids     = var.endpoint_type == "Gateway" ? var.private_route_table_ids : null
  security_group_ids  = var.endpoint_type == "Interface" ? var.security_group_ids : null
  private_dns_enabled = var.endpoint_type == "Interface" ? var.private_dns_enabled : null

  tags = {
    Name        = "${var.project_name}-${var.endpoint_service_name}"
    Environment = var.environment
  }
}

# # S3 Endpoint (Gateway type)
# resource "aws_vpc_endpoint" "s3" {
#   vpc_id            = var.vpc_id
#   service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
#   vpc_endpoint_type = "Gateway"
#   route_table_ids   = var.private_route_table_ids

#   tags = {
#     Name        = "${var.project_name}-s3-endpoint"
#     Environment = var.environment
#   }
# }
