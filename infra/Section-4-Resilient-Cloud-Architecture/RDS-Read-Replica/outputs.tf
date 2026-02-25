output "rds_endpoint" {
  value = aws_db_instance.app_db.endpoint
}

output "rds_port" {
  value = aws_db_instance.app_db.port
}

output "read_replica_endpoint" {
  value = aws_db_instance.read_replica.endpoint
}
