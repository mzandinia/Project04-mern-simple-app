resource "aws_ssm_parameter" "parameter" {
  name        = var.name
  description = var.description
  type        = var.type
  value       = var.value
  key_id      = var.type == "SecureString" ? var.kms_key_id : null
  tier        = var.tier
  tags        = var.tags

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}