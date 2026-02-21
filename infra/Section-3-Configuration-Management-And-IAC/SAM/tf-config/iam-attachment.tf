locals {
  policy_arns = toset([
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess",
    "arn:aws:iam::aws:policy/AWSLambda_FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess"
  ])
}

resource "aws_iam_role_policy_attachment" "ec2_access" {
  for_each   = local.policy_arns
  role       = aws_iam_role.ec2_service_role1.name
  policy_arn = each.value
}