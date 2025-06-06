# output "repository_url" {
#   description = "The URL of the repository"
#   value       = aws_ecr_repository.backend.repository_url
# }

# output "repository_arn" {
#   description = "The ARN of the repository"
#   value       = aws_ecr_repository.backend.arn
# }

# output "registry_id" {
#   description = "The registry ID where the repository was created"
#   value       = aws_ecr_repository.backend.registry_id
# }

# output "docdb_cluster_endpoint" {
#   description = "The access endpoint of the DocumentDB cluster"
#   value       = aws_docdb_cluster.default.endpoint
# }

# output "cloudfront_domain_name" {
#   description = "CloudFront domain name to access the frontend"
#   value       = aws_cloudfront_distribution.frontend_distribution.domain_name
# }

# output "alb_dns_name" {
#   description = "DNS name of the internal ALB"
#   value       = aws_lb.backend.dns_name
# }

# output "vpc_id" {
#   description = "ID of the VPC"
#   value       = aws_vpc.main.id
# }

# output "frontend_bucket_name" {
#   description = "Name of the S3 bucket hosting frontend assets"
#   value       = aws_s3_bucket.frontend_bucket.bucket
# }

# output "aws_region" {
#   description = "AWS region where resources are deployed"
#   value       = var.aws_region
# }

# output "cluster_name" {
#   description = "Name of the ECS cluster"
#   value       = aws_ecs_cluster.main.name
# }

# output "service_name" {
#   description = "Name of the ECS service"
#   value       = aws_ecs_service.backend.name
# }