resource "aws_apprunner_service" "backend" {

  service_name = "mern-app-backend"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner.arn
    }

    image_repository {
      image_configuration {
        port = "3000"
        runtime_environment_secrets = {
          DBUsername = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/docdb/master/username"
          DBPassword = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/docdb/master/password"
        }
        runtime_environment_variables = {
          DBHost = aws_docdb_cluster.default.endpoint
          DBPort = "27017"
        }
      }
      image_identifier      = "${aws_ecr_repository.backend.repository_url}:latest"
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = true
  }

  instance_configuration {
    cpu               = "0.5 vCPU"
    memory            = "1 GB"
    instance_role_arn = aws_iam_role.apprunner.arn
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.docdb.arn
    }
    ingress_configuration {
      is_publicly_accessible = true
    }
  }

  health_check_configuration {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 1
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 20
  }
}

# Get current region and account ID
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Get SSM parameters for DocumentDB URI construction
data "aws_ssm_parameter" "docdb_username" {
  name = "/docdb/master/username"
}

data "aws_ssm_parameter" "docdb_password" {
  name            = "/docdb/master/password"
  with_decryption = true
}

resource "aws_iam_role" "apprunner" {
  name = "apprunner-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "build.apprunner.amazonaws.com",
            "tasks.apprunner.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "apprunner_policy" {
  name = "apprunner-policy"
  role = aws_iam_role.apprunner.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Resource = [
          "arn:aws:ssm:*:*:parameter/docdb/master/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = [
          "arn:aws:logs:*:*:log-group:/aws/apprunner/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets",
          "xray:GetSamplingStatisticSummaries"
        ]
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetAuthorizationToken"
        ]
        Resource = ["*"]
      }
    ]
  })
}
