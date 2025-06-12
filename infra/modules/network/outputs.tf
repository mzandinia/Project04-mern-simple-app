output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = var.create_public_subnets ? aws_subnet.public[*].id : []
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = var.create_private_subnets ? aws_subnet.private[*].id : []
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = var.create_public_subnets && var.create_private_subnets ? aws_nat_gateway.nat[0].id : null
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = var.create_public_subnets ? aws_internet_gateway.igw[0].id : null
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = var.create_public_subnets ? aws_route_table.public[0].id : null
}

output "private_route_table_ids" {
  description = "IDs of the private route tables"
  value = var.create_private_subnets ? [aws_route_table.private[0].id] : []
}