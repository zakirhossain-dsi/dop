/*output "encrypted_console_password" {
  value     = aws_iam_user_login_profile.console_access.encrypted_password
  sensitive = true
}*/

output "ia_account_signin_url" {
  value = "https://${data.aws_caller_identity.ia.account_id}.signin.aws.amazon.com/console"
}

output "sa_switch_role_url" {
  value = "https://${data.aws_caller_identity.sa.account_id}.signin.aws.amazon.com/switchrole?account=${data.aws_caller_identity.sa.account_id}&role=${aws_iam_role.cross_account_role.name}&displayName=SecuryAccount"
}