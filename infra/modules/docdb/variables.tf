variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DocumentDB subnet group"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the DocumentDB cluster"
  type        = list(string)
}

variable "master_username_ssm_parameter" {
  description = "SSM parameter path for the DocumentDB master username"
  type        = string
  default     = "/docdb/master/username"
}

variable "master_password_ssm_parameter" {
  description = "SSM parameter path for the DocumentDB master password"
  type        = string
  default     = "/docdb/master/password"
}

variable "instance_count" {
  description = "Number of DB instances to create in the cluster"
  type        = number
  default     = 1
}

variable "instance_class" {
  description = "Instance class to use for the DB instances"
  type        = string
  default     = "db.t3.medium"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  type        = bool
  default     = false
}

variable "backup_window" {
  description = "Daily time range during which automated backups are created"
  type        = string
  default     = "07:00-09:00"
}

variable "maintenance_window" {
  description = "Weekly time range during which system maintenance can occur"
  type        = string
  default     = "sun:05:00-sun:07:00"
}

variable "backup_retention_period" {
  description = "Number of days to retain backups for"
  type        = number
  default     = 5
}

variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}