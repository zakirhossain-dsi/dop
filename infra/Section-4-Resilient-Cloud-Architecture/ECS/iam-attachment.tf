locals {
  policy_arns = toset([
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ])
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attachment" {
  for_each   = local.policy_arns
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = each.value
}