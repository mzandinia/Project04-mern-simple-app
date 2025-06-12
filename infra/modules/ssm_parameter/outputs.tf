output "arn" {
  description = "The ARN of the parameter"
  value       = aws_ssm_parameter.parameter.arn
}

output "name" {
  description = "The name of the parameter"
  value       = aws_ssm_parameter.parameter.name
}

output "version" {
  description = "The version of the parameter"
  value       = aws_ssm_parameter.parameter.version
}