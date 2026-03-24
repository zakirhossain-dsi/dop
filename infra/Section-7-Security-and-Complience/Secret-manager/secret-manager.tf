resource "aws_secretsmanager_secret" "db_secret" {
  name        = "db-credentials"
  description = "Secret for ${var.project_name} application"
  tags        = var.default_tags
}

resource "aws_secretsmanager_secret_version" "db_secret_value" {
  secret_id = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = var.db_username,
    password = var.db_password
  })
}