resource "aws_docdb_subnet_group" "default" {
  name       = "${var.project_name}-docdb-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name        = "${var.project_name}-docdb-subnet-group"
    Environment = var.environment
  }
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "${var.project_name}-docdb-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.default.id
  instance_class     = "db.t3.medium"
}

resource "aws_docdb_cluster" "default" {
  cluster_identifier              = "${var.project_name}-docdb-cluster"
  engine                          = "docdb"
  master_username                 = var.docdb_master_username
  master_password                 = var.docdb_master_password
  db_subnet_group_name            = aws_docdb_subnet_group.default.name
  vpc_security_group_ids          = [aws_security_group.docdb.id]
  skip_final_snapshot             = true
  deletion_protection             = false
  preferred_backup_window         = "07:00-09:00"
  preferred_maintenance_window    = "sun:05:00-sun:07:00"
  backup_retention_period         = 5
  storage_encrypted               = true
  
  tags = {
    Name        = "${var.project_name}-docdb-cluster"
    Environment = var.environment
  }
}