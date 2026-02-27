locals {
  identifiers = {
    lambda = "lambda.amazonaws.com"
  }
}

data "aws_iam_policy_document" "assume_role_doc" {
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
  name               = "${each.key}_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_doc[each.key].json
  tags               = var.default_tags

}