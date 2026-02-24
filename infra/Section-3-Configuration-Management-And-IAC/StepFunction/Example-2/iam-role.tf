locals {
  identifiers = {
    cw_events               = "events.amazonaws.com"
    state_machine           = "states.amazonaws.com"
    lambda                  = "lambda.amazonaws.com"
    lambda_request_approval = "lambda.amazonaws.com"
    lambda_approver         = "lambda.amazonaws.com"
    lambda_remediator       = "lambda.amazonaws.com"
  }
}

data "aws_iam_policy_document" "assume_policy" {
  for_each = local.identifiers
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = [each.value]
    }
  }
}

resource "aws_iam_role" "iam_roles" {
  for_each           = local.identifiers
  name               = "${var.project_name}-${each.key}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_policy[each.key].json
}