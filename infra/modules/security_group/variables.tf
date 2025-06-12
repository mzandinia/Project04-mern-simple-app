variable "name" {
  description = "Name of the security group"
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of the security group"
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = "ID of the VPC where to create the security group"
  type        = string
  default     = ""
}

variable "ingress_with_ports" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(map(string))
  default     = []
}

variable "egress_with_ports" {
  description = "List of IPv4 CIDR ranges to use on all egress rules"
  type        = list(map(string))
  default     = []
}

variable "egress_all_traffic" {
  description = "Allow all egress traffic"
  type        = list(map(string))
  default     = []
}

variable "referenced_security_group_id" {
  description = "ID of the security group to reference in ingress rules"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to security group"
  type        = map(string)
  default     = {}
}