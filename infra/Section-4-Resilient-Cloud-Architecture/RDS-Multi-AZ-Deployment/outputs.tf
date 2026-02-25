output "cluster_endpoint" {
  value = aws_rds_cluster.db.endpoint
}

output "reader_endpoint" {
  value = aws_rds_cluster.db.reader_endpoint
}