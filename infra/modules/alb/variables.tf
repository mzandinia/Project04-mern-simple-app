variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "internal" {
  description = "Whether the load balancer is internal or internet-facing"
  type        = bool
  default     = true
}

variable "security_group_id" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be created"
  type        = string
}

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection for the ALB"
  type        = bool
  default     = false
}

variable "target_port" {
  description = "Port for the target group"
  type        = number
  default     = 3000
}

variable "target_protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

variable "target_type" {
  description = "Type of target for the target group (instance, ip, lambda)"
  type        = string
  default     = "ip"
}

variable "health_check_enabled" {
  description = "Whether health checks are enabled"
  type        = bool
  default     = true
}

variable "health_check_interval" {
  description = "Interval between health checks in seconds"
  type        = number
  default     = 30
}

variable "health_check_path" {
  description = "Path for health checks"
  type        = string
  default     = "/health"
}

variable "health_check_port" {
  description = "Port for health checks"
  type        = string
  default     = "traffic-port"
}

variable "health_check_healthy_threshold" {
  description = "Number of consecutive successful health checks required to consider a target healthy"
  type        = number
  default     = 3
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive failed health checks required to consider a target unhealthy"
  type        = number
  default     = 3
}

variable "health_check_timeout" {
  description = "Timeout for health checks in seconds"
  type        = number
  default     = 5
}

variable "health_check_protocol" {
  description = "Protocol for health checks"
  type        = string
  default     = "HTTP"
}

variable "health_check_matcher" {
  description = "HTTP codes to use when checking for a successful response from a target"
  type        = string
  default     = "200"
}

variable "enable_https" {
  description = "Whether to enable HTTPS listener"
  type        = bool
  default     = true
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate to use for HTTPS listener"
  type        = string
  default     = ""
}

variable "certificate_common_name" {
  description = "Common name for the self-signed certificate"
  type        = string
  default     = "example.com"
}

variable "certificate_organization" {
  description = "Organization for the self-signed certificate"
  type        = string
  default     = "Example Organization"
}

variable "certificate_validity_period_hours" {
  description = "Validity period for the self-signed certificate in hours"
  type        = number
  default     = 12
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}