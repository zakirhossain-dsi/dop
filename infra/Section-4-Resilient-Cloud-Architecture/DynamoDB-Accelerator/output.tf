output "dax_cluster_arn" {
  description = "ARN of the DAX Cluster"
  value       = aws_dax_cluster.dax.arn
}

output "dax_cluster_endpoint" {
  description = "Endpoint of the DAX Cluster"
  value       = "dax://${aws_dax_cluster.dax.cluster_address}:8111"
}