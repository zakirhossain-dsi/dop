resource "aws_iam_user" "alice" {
  name = "Alice"
  path = "/development/"
  tags = {
    Project = var.project_name
  }
}

resource "aws_iam_user_login_profile" "alice_console" {
  user                    = aws_iam_user.alice.name
  password_length         = 8
  password_reset_required = false
}
