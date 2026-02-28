resource "aws_iam_role_policy_attachment" "dax_role_attachment" {
  policy_arn = aws_iam_policy.dax_access_policy.arn
  role       = aws_iam_role.dax_role.name
}