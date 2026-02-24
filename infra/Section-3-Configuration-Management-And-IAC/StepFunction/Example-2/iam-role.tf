locals {
  service_identifiers = {
    event  = "events.amazonaws.com"
    states = "states.amazonaws.com"
    lambda = "lambda.amazonaws.com"
  }
  role_trust = {
    cw_events               = local.service_identifiers.event
    state_machine           = local.service_identifiers.states
    lambda                  = local.service_identifiers.lambda
    lambda_request_approval = local.service_identifiers.lambda
    lambda_approver         = local.service_identifiers.lambda
    lambda_remediator       = local.service_identifiers.lambda
  }
}

data "aws_iam_policy_document" "assume_policy" {
  for_each = local.role_trust
  statement {
    sid     = "AssumeRole"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = [each.value]
    }
  }
}

resource "aws_iam_role" "iam_roles" {
  for_each           = local.role_trust
  name               = "${var.project_name}-${each.key}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_policy[each.key].json
}