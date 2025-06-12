resource "aws_iam_role" "this" {
  name        = var.role_name
  description = var.role_description
  assume_role_policy = var.custom_assume_role_policy != null ? var.custom_assume_role_policy : jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = var.trusted_services
        }
      },
    ]
  })

  tags = merge(
    {
      Name = var.role_name
    },
    var.tags
  )
}

resource "aws_iam_role_policy" "this" {
  name = var.role_policy_name
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = local.create_inline_policy ? jsondecode(data.aws_iam_policy_document.inline[0].json).Statement : var.policy_statements
  })
}

locals {
  create_inline_policy = length(var.inline_policy_statements) > 0
}

data "aws_iam_policy_document" "inline" {
  count = local.create_inline_policy ? 1 : 0

  dynamic "statement" {
    for_each = var.inline_policy_statements

    content {
      sid           = try(statement.value.sid, null)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      effect        = try(statement.value.effect, null)
      resources     = try(statement.value.resources, null)
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = try(statement.value.not_principals, [])

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}

# resource "aws_iam_role" "this" {
#   name = var.role_name

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         }
#       },
#     ]
#   })
# }

# resource "aws_iam_role_policy" "ecsExecutionRole_policy" {
#   name = var.role_policy_name
#   role = aws_iam_role.this.id

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     Version = "2012-10-17"
#     "Statement" : [
#       {
#         "Effect" : "Allow",
#         "Action" : [
#           "ecr:GetAuthorizationToken",
#           "ecr:BatchCheckLayerAvailability",
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:BatchGetImage",
#           "logs:CreateLogStream",
#           "logs:PutLogEvents",
#           "ssm:GetParameter",
#           "ssm:GetParameters"
#         ],
#         "Resource" : "*"
#       }
#     ]
#   })
# }

