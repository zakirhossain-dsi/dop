locals {
  role_policy_attachments = {
    cw_events     = ["events_policy"]
    state_machine = ["sfn_policy"]
    lambda        = ["lambda_policy"]
    lambda_request_approval = [
      "lambda_policy", "lambda_request_approval_policy"
    ]
    lambda_approver = [
      "lambda_policy", "lambda_approver_callback_policy"
    ]
    lambda_remediator = [
      "lambda_policy", "lambda_remediator_policy"
    ]
  }
  policy_arn_map = {
    events_policy                   = aws_iam_policy.events_policy.arn,
    sfn_policy                      = aws_iam_policy.sfn_policy.arn,
    lambda_policy                   = aws_iam_policy.lambda_policy.arn,
    lambda_request_approval_policy  = aws_iam_policy.lambda_request_approval_policy.arn,
    lambda_approver_callback_policy = aws_iam_policy.lambda_approver_callback_policy.arn,
    lambda_remediator_policy        = aws_iam_policy.lambda_remediator_policy.arn
  }

  # ✅ flatten role->policy lists into a LIST of OBJECTS
  role_policy_pairs_list = flatten([
    for role_key, policy_names in local.role_policy_attachments : [
      for policy_name in policy_names : {
        role_key    = role_key
        policy_name = policy_name
      }
    ]
  ])

  # ✅ convert list into a MAP with static keys
  role_policy_pairs = {
    for pair in local.role_policy_pairs_list :
    "${pair.role_key}|${pair.policy_name}" => pair
  }
}

resource "aws_iam_role_policy_attachment" "attachments" {
  for_each   = local.role_policy_pairs
  role       = aws_iam_role.iam_roles[each.value.role_key].name
  policy_arn = local.policy_arn_map[each.value.policy_name]
}