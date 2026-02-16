resource "aws_iam_role_policy_attachment" "codebuild_attach" {
  role       = aws_iam_role.roles["codebuild"].name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.roles["lambda"].name
  policy_arn = aws_iam_policy.lambda_policy.arn
}