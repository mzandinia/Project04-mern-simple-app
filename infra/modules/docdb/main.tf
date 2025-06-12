resource "aws_docdb_subnet_group" "this" {
  name       = "${var.name_prefix}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-subnet-group"
    }
  )
}

data "aws_ssm_parameter" "master_username" {
  name = var.master_username_ssm_parameter
}

data "aws_ssm_parameter" "master_password" {
  name = var.master_password_ssm_parameter
}

resource "aws_docdb_cluster" "this" {
  cluster_identifier           = "${var.name_prefix}-cluster"
  engine                       = "docdb"
  master_username              = data.aws_ssm_parameter.master_username.value
  master_password              = data.aws_ssm_parameter.master_password.value
  db_subnet_group_name         = aws_docdb_subnet_group.this.name
  vpc_security_group_ids       = var.security_group_ids
  skip_final_snapshot          = var.skip_final_snapshot
  deletion_protection          = var.deletion_protection
  preferred_backup_window      = var.backup_window
  preferred_maintenance_window = var.maintenance_window
  backup_retention_period      = var.backup_retention_period
  storage_encrypted            = var.storage_encrypted

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-cluster"
    }
  )
}

resource "aws_docdb_cluster_instance" "instances" {
  count              = var.instance_count
  identifier         = "${var.name_prefix}-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.this.id
  instance_class     = var.instance_class

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-instance-${count.index}"
    }
  )
}