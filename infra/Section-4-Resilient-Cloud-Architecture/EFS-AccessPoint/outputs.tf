output "instance_public_ips" {
  value = aws_instance.efs_client.public_ip
}

output "efs_id" {
  value = aws_efs_file_system.shared_efs.id
}

output "efs_access_point_ids" {
  value = aws_efs_access_point.efs_access_points[*].id
}