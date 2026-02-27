locals {
  lambda_policies = toset([
    "arn:aws:iam::aws:policy/CloudWatchFullAccess",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  ])
}
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  for_each   = local.lambda_policies
  policy_arn = each.value
  role       = aws_iam_role.roles["lambda"].name
}