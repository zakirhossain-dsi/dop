output "account_a_id" {
  value = data.aws_caller_identity.account_a.account_id
}

output "account_b_id" {
  value = data.aws_caller_identity.account_b.account_id
}

output "efs_id" {
  value = aws_efs_file_system.shared.id
}

output "efs_dns_name" {
  value = local.efs_dns_name
}

output "selected_mount_target_ip" {
  value = local.selected_mount_target_ip
}

output "ec2_public_ip" {
  value = aws_instance.efs_client.public_ip
}

output "assume_role_arn_account_a" {
  value = aws_iam_role.efs_access_role.arn
}