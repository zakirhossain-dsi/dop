resource "aws_iam_user" "alice" {
  provider = aws.ia
  name     = "Alice"
  tags = {
    Name = "Alice"
  }
}

/*resource "aws_iam_user_login_profile" "console_access" {
  provider                = aws.ia
  user                    = aws_iam_user.alice.name
  password_reset_required = false
  pgp_key                 = var.ia_pgp_key
}*/

resource "aws_iam_user_policy" "cross_account_access_policy" {
  provider = aws.ia
  name     = "CrossAccountAssumeRolePolicy"
  user     = aws_iam_user.alice.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sts:AssumeRole",
        Resource = "arn:aws:iam::${data.aws_caller_identity.sa.account_id}:role/${aws_iam_role.cross_account_role.name}"
      }
    ]
  })
}
