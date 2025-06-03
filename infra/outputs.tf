output "repository_url" {
  description = "The URL of the repository"
  value       = aws_ecr_repository.backend.repository_url
}

output "repository_arn" {
  description = "The ARN of the repository"
  value       = aws_ecr_repository.backend.arn
}

output "registry_id" {
  description = "The registry ID where the repository was created"
  value       = aws_ecr_repository.backend.registry_id
}
