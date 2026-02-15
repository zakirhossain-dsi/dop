locals {
  identifiers = {
    codebuild = "codebuild.amazonaws.com"
    lambda    = "lambda.amazonaws.com"
  }
}

data "aws_iam_policy_document" "assume_policies" {
  for_each = local.identifiers
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
  for_each           = local.identifiers
  name               = "${var.project_name}-${each.key}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_policies[each.key].json
}