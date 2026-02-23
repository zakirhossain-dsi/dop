locals {
  sfn_definition = {
    Comment = "AdminAccess attachment approval workflow"
    StartAt = "Validate"
    States = {
      Validate = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"
        Parameters = {
          FunctionName = aws_lambda_function.validator.arn
          "Payload.$"  = "$"
        }
        OutputPath = "$.Payload"
        End        = true
      }
    }
  }
}

resource "aws_sfn_state_machine" "security_workflow" {
  name       = "${var.project_name}-admin-access-approval-workflow"
  role_arn   = aws_iam_role.iam_roles["state_machine"].arn
  definition = jsonencode(local.sfn_definition)
}