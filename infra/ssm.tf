# # Store DocumentDB credentials in Parameter Store
# resource "aws_ssm_parameter" "docdb_username" {
#   name        = "/docdb/master/username"
#   description = "DocumentDB master username"
#   type        = "SecureString"
#   value       = var.docdb_master_username
# }

# resource "aws_ssm_parameter" "docdb_password" {
#   name        = "/docdb/master/password"
#   description = "DocumentDB master password"
#   type        = "SecureString"
#   value       = var.docdb_master_password
# }