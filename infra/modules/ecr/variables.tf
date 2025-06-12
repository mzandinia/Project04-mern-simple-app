variable "repository_name" {
  description = "The name of the repository"
  type        = string
  default     = ""

  validation {
    condition     = length(var.repository_name) > 0
    error_message = "ECR repository name is required. You must set a name for the ECR repository."
  }
}

variable "repository_image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`. Defaults to `IMMUTABLE`"
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition     = var.repository_image_tag_mutability == "MUTABLE" || var.repository_image_tag_mutability == "IMMUTABLE"
    error_message = "The tag mutability setting for the repository must be one of: `MUTABLE` or `IMMUTABLE`"
  }
}

variable "repository_encryption_type" {
  description = "The encryption type for the repository. Must be one of: `KMS` or `AES256`. Defaults to `AES256`"
  type        = string
  default     = null
}

variable "repository_kms_key" {
  description = "The ARN of the KMS key to use when encryption_type is `KMS`. If not specified, uses the default AWS managed key for ECR"
  type        = string
  default     = null
}

variable "repository_image_scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository (`true`) or not scanned (`false`)"
  type        = bool
  default     = true
}

variable "repository_force_delete" {
  description = "If `true`, will delete the repository even if it contains images. Defaults to `false`"
  type        = bool
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}