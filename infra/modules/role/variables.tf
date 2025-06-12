variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "role_description" {
  description = "Description of the IAM role"
  type        = string
  default     = "Role created by Terraform"
}

variable "role_policy_name" {
  description = "Name of the inline policy attached to the role"
  type        = string
}

variable "trusted_services" {
  description = "AWS services that can assume this role"
  type        = list(string)
  default     = ["ecs-tasks.amazonaws.com"]
}

variable "custom_assume_role_policy" {
  description = "Custom assume role policy JSON (overrides trusted_services if provided)"
  type        = string
  default     = null
}

variable "inline_policy_statements" {
  description = "Map of dynamic policy statements to include in IAM role policy"
  type        = any
  default     = {}
}

variable "policy_statements" {
  description = "List of policy statements to include in the role policy"
  type        = any
  default     = []
}

variable "tags" {
  description = "A map of tags to add to the IAM role"
  type        = map(string)
  default     = {}
}
