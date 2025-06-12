variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where endpoints will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
  default     = []
}

variable "private_route_table_ids" {
  description = "List of private route table IDs"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the endpoint"
  type        = list(string)
  default     = []
}

variable "endpoint_type" {
  description = "Type of VPC endpoint (Interface or Gateway)"
  type        = string
  default     = "Interface"
  
  validation {
    condition     = contains(["Interface", "Gateway"], var.endpoint_type)
    error_message = "Endpoint type must be either Interface or Gateway."
  }
}

variable "endpoint_service_name" {
  description = "Service name for the VPC endpoint (e.g., ssm, ecr.api)"
  type        = string
}

variable "private_dns_enabled" {
  description = "Whether to enable private DNS for Interface endpoints"
  type        = bool
  default     = true
}