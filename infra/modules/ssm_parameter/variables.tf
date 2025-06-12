variable "name" {
  description = "The name of the parameter"
  type        = string
}

variable "description" {
  description = "The description of the parameter"
  type        = string
  default     = ""
}

variable "type" {
  description = "The type of the parameter. Valid types are String, StringList and SecureString"
  type        = string
  default     = "SecureString"

  validation {
    condition     = contains(["String", "StringList", "SecureString"], var.type)
    error_message = "The parameter type must be String, StringList, or SecureString."
  }
}

variable "value" {
  description = "The value of the parameter"
  type        = string
  sensitive   = true
}

variable "kms_key_id" {
  description = "The KMS key ID to use for encryption. Only applicable for SecureString type"
  type        = string
  default     = null
}

variable "tier" {
  description = "The tier of the parameter. Valid tiers are Standard, Advanced, and Intelligent-Tiering"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Advanced", "Intelligent-Tiering"], var.tier)
    error_message = "The parameter tier must be Standard, Advanced, or Intelligent-Tiering."
  }
}

variable "tags" {
  description = "A map of tags to assign to the parameter"
  type        = map(string)
  default     = {}
}