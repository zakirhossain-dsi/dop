resource "aws_cloudwatch_event_rule" "admin_access_attached" {
  name        = "${var.project_name}-admin-access-attached-events"
  description = "Triggers when AdministratorAccess is attached to an IAM user"
  event_pattern = jsonencode({
    source        = ["aws.iam"]
    "detail-type" = ["AWS API Call via CloudTrail"]
    detail = {
      "eventSource" = ["iam.amazonaws.com"]
      "eventName"   = ["AttachUserPolicy"]
      "requestParameters" = {
        "userName"  = [aws_iam_user.student.name]
        "policyArn" = [var.admin_access_policy_arn]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "start_security_workflow" {
  rule     = aws_cloudwatch_event_rule.admin_access_attached.name
  arn      = aws_sfn_state_machine.security_workflow.arn
  role_arn = aws_iam_role.iam_roles["cw_events"].arn
}