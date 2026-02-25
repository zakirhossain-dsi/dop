output "template_url" {
  value = local.template_url
}
output "alice_console_password" {
  value     = aws_iam_user_login_profile.alice_console.password
  sensitive = true
}
