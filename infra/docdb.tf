# resource "aws_docdb_cluster_instance" "cluster_instances" {
#   count              = 1
#   identifier         = "docdb-cluster-demo-${count.index}"
#   cluster_identifier = aws_docdb_cluster.default.id
#   instance_class     = "db.t3.medium"
# }

# resource "aws_docdb_cluster" "default" {
#   cluster_identifier = "docdb-cluster-demo"
#   availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
#   master_username    = var.docdb_master_username
#   master_password    = var.docdb_master_password
# }