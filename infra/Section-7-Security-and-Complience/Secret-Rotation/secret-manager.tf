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

#resource "aws_secretsmanager_secret_rotation" "db_secret_rotation" {
#    secret_id = aws_secretsmanager_secret.db_secret.id
#    rotation_lambda_arn = aws_lambda_function.secret_rotation_lambda.arn
#    rotation_rules {
#        automatically_after_days = 30
#    }
#}