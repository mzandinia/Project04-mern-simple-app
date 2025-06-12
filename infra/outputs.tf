# ECR outputs
output "repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "repository_arn" {
  description = "ARN of the ECR repository"
  value       = module.ecr.repository_arn
}

output "registry_id" {
  description = "The registry ID where the repository was created"
  value       = module.ecr.registry_id
}

output "repository_name" {
  description = "The registry ID where the repository was created"
  value       = module.ecr.name
}
# # ECS outputs
# output "cluster_name" {
#   description = "Name of the ECS cluster"
#   value       = aws_ecs_cluster.main.name
# }

# output "service_name" {
#   description = "Name of the ECS service"
#   value       = aws_ecs_service.backend.name
# }

# # Frontend outputs
# output "frontend_bucket_name" {
#   description = "Name of the S3 bucket hosting the frontend"
#   value       = aws_s3_bucket.frontend.id
# }

# output "cloudfront_domain_name" {
#   description = "Domain name of the CloudFront distribution"
#   value       = aws_cloudfront_distribution.frontend.domain_name
# }