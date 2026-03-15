output "instance_public_ips" {
  value = aws_instance.efs_clients[*].public_ip
}

output "efs_id" {
  value = aws_efs_file_system.shared_efs.id
}