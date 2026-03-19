resource "aws_iam_role_policy_attachment" "cw_agent_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.roles["ec2-cloudwatch"].name
}