# # Get VPC and subnet information
# data "aws_vpc" "default" {
#   default = true
# }

# data "aws_subnets" "default" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.default.id]
#   }
# }

# # VPC Connector for App Runner
# resource "aws_apprunner_vpc_connector" "docdb" {
#   vpc_connector_name = "docdb-connector"
#   subnets            = slice(data.aws_subnets.default.ids, 0, 2) # Use actual subnet IDs
#   security_groups    = [aws_security_group.apprunner_docdb.id]
# }