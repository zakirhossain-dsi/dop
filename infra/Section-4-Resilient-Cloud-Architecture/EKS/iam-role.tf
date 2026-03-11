locals {
  identifiers = {
    eks_cluster    = "eks.amazonaws.com"
    eks_node_group = "ec2.amazonaws.com"
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  for_each = local.identifiers
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = [each.value]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "roles" {
  for_each           = local.identifiers
  name               = "${each.key}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy[each.key].json
}