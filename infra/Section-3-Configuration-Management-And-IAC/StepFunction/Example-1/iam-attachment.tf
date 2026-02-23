resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.roles["lambda"].name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.roles["lambda"].name
}

resource "aws_iam_role_policy_attachment" "sfn_policy_attach" {
  policy_arn = aws_iam_policy.sfn_policy.arn
  role       = aws_iam_role.roles["stepfunction"].name
}