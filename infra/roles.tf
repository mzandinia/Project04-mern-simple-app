module "ecsRole" {
  source           = "./modules/role"
  role_name        = "ecsExecutionRoleDemo"
  role_description = "ECS Execution Role for running tasks"
  role_policy_name = "ecsExecutionPolicyDemo"

  # Optional: customize trusted services
  trusted_services = ["ecs-tasks.amazonaws.com"]
  # trusted_services = ["ecs-tasks.amazonaws.com", "lambda.amazonaws.com"]

  # Optional: customize policy statements
  policy_statements = [
    {
      Effect = "Allow",
      Action = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:DescribeImages",
        "ecr:ListImages",
        "ecr:DescribePullThroughCacheRules",
        "ecr:DescribeRegistry",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ssm:GetParameter",
        "ssm:GetParameters"
      ],
      Resource = "*"
    }
  ]

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
