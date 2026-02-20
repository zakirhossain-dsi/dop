resource "aws_iam_role_policy_attachment" "cf_execution_role_attachment" {
  role       = aws_iam_role.cf_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "cf_admin_role_attachment" {
  policy_arn = aws_iam_policy.cf_admin_assume_policy.arn
  role       = aws_iam_role.cf_admin_role.name
}