locals {
  ec2_policies = toset([
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  ])
}

resource "aws_iam_role_policy_attachment" "ec2_policies" {
  for_each   = local.ec2_policies
  policy_arn = each.value
  role       = aws_iam_role.roles["ec2"].id
}