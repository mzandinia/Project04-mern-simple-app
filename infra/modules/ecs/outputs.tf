output "cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.this.id
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.this.arn
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.this.name
}

output "service_id" {
  description = "ID of the ECS service"
  value       = aws_ecs_service.this.id
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.this.name
}

output "service_arn" {
  description = "ARN of the ECS service"
  value       = aws_ecs_service.this.id
}

output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = aws_ecs_task_definition.this.arn
}

output "task_definition_family" {
  description = "Family of the task definition"
  value       = aws_ecs_task_definition.this.family
}

# output "task_execution_role_arn" {
#   description = "ARN of the task execution role"
#   value       = aws_iam_role.ecs_task_execution_role.arn
# }

# output "task_role_arn" {
#   description = "ARN of the task role"
#   value       = aws_iam_role.ecs_task_role.arn
# }

output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.this.name
}

output "log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.this.arn
}

# output "execution_role_name" {
#   description = "Name of the ECS task execution IAM role"
#   value       = aws_iam_role.execution_role.name
# }

# output "execution_role_arn" {
#   description = "ARN of the ECS task execution IAM role"
#   value       = aws_iam_role.execution_role.arn
# }
