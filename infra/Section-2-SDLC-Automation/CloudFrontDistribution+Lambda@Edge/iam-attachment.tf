resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.roles["lambda"].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}