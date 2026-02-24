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
        Next       = "CheckAdminAccess"
      }
      CheckAdminAccess = {
        Type = "Choice"
        Choices = [
          {
            Variable      = "$.isAdminAccess"
            BooleanEquals = true
            Next          = "CheckUserName"
          }
        ]
        Default = "EndState"
      }
      CheckUserName = {
        Type = "Choice"
        Choices = [
          {
            Variable  = "$.userName"
            IsPresent = true
            Next      = "RequestApproval"
          }
        ]
        Default = "EndState"
      }
      RequestApproval = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke.waitForTaskToken"
        Parameters = {
          FunctionName = aws_lambda_function.request_approval.arn
          Payload = {
            "taskToken.$"        = "$$.Task.Token"
            "event.$"            = "$"
            "approvalApiBaseUrl" = "https://abc.com/approval"
          }
        }
        TimeoutSeconds = 120
        Catch = [
          { ErrorEquals = ["States.Timeout"], Next = "EndState" },
          { ErrorEquals = ["States.TaskFailed"], Next = "EndState" }
        ]
        Next = "EndState"
      }
      EndState = {
        Type = "Succeed"
      }
    }
  }
}

resource "aws_sfn_state_machine" "security_workflow" {
  name       = "${var.project_name}-admin-access-approval-workflow"
  role_arn   = aws_iam_role.iam_roles["state_machine"].arn
  definition = jsonencode(local.sfn_definition)
}