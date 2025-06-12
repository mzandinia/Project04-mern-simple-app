# ECR outputs
output "repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "cluster_endpoint" {
  description = "The connection endpoint for the DocumentDB cluster"
  value       = module.docdb.endpoint
}