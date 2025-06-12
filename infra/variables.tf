variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "demo-project1"
}

variable "repository_name" {
  description = "The name of the repository"
  type        = string
  default     = "demo-project1-registry"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.100.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.100.10.0/24"]
}

variable "ecs_task_desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 2
}

variable "docdb_master_username" {
  description = "Master username for the DocumentDB cluster"
  type        = string
  sensitive   = true
  default     = ""
}

variable "docdb_master_password" {
  description = "Master password for the DocumentDB cluster"
  type        = string
  sensitive   = true
  default     = ""
}