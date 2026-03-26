resource "aws_iam_group_policy_attachment" "ec2_policy_attachment" {
  policy_arn = aws_iam_policy.ec2_policy.arn
  group      = aws_iam_group.devops.name
}