locals {
  eb_policies  = var.eb_policies
  ec2_policies = var.ec2_policies
}

resource "aws_iam_role_policy_attachment" "eb_env_service_policies" {
  for_each   = toset(local.eb_policies)
  role       = aws_iam_role.roles["eb-service"].id
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "eb_env_ec2_policies" {
  for_each   = toset(local.ec2_policies)
  role       = aws_iam_role.roles["eb-ec2"].id
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "${var.project_name}-eb-ec2-profile"
  role = aws_iam_role.roles["eb-ec2"].name
}