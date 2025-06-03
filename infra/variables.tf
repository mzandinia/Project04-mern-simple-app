variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "mern-app"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "mern-app-backend"
}

variable "image_tag_mutability" {
  description = "Image tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = false
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