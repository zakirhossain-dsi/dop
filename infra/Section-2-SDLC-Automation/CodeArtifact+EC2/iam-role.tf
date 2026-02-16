locals {
  assume_roles = {
    ec2 = "ec2.amazonaws.com"
  }
}

data "aws_iam_policy_document" "assume_role" {
  for_each = local.assume_roles
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = [each.value]
    }
  }
}

resource "aws_iam_role" "roles" {
  for_each           = local.assume_roles
  name               = "${var.project_name}-${each.key}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role[each.key].json
}