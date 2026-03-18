resource "aws_iam_role_policy_attachment" "file_gateway_s3_policy_attachment" {
  policy_arn = aws_iam_policy.file_gateway_s3_policy.arn
  role       = aws_iam_role.file_gateway.name
}