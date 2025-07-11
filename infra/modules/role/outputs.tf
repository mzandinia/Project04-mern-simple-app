output "role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.this.arn
}

output "role_id" {
  description = "ID of the IAM role"
  value       = aws_iam_role.this.id
}

output "role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.this.name
}
