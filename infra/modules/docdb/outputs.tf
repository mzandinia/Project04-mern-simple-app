output "cluster_id" {
  description = "The ID of the DocumentDB cluster"
  value       = aws_docdb_cluster.this.id
}

output "cluster_endpoint" {
  description = "The connection endpoint for the DocumentDB cluster"
  value       = aws_docdb_cluster.this.endpoint
}

output "reader_endpoint" {
  description = "The reader endpoint for the DocumentDB cluster"
  value       = aws_docdb_cluster.this.reader_endpoint
}

output "port" {
  description = "The port on which the DocumentDB cluster accepts connections"
  value       = aws_docdb_cluster.this.port
}

output "instance_ids" {
  description = "List of IDs of the DocumentDB instances"
  value       = aws_docdb_cluster_instance.instances[*].id
}

output "subnet_group_id" {
  description = "The ID of the DocumentDB subnet group"
  value       = aws_docdb_subnet_group.this.id
}

output "subnet_group_name" {
  description = "The name of the DocumentDB subnet group"
  value       = aws_docdb_subnet_group.this.name
}