resource "aws_iam_role_policy_attachment" "vpc_flow_logs_attachment" {
  policy_arn = aws_iam_policy.vpc_flow_logs_policy.arn
  role       = aws_iam_role.vpc_flow_logs_role.name
}