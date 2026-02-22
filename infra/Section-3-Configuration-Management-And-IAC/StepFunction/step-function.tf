locals {
  sfn_definition = {
    Comment = "Choice -> invoke lambda based on input.selection"
    StartAt = "ChooseOption"
    States = {
      ChooseOption = {
        Type = "Choice"
        Choices = [
          {
            Variable     = "$.course"
            StringEquals = "terraform"
            Next         = "InvokeTerraformLambda"
          },
          {
            Variable     = "$.course"
            StringEquals = "aws"
            Next         = "InvokeAWSLambda"
          }
        ]
        Default = "InvalidCourse"
      }
      InvokeTerraformLambda = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"
        Parameters = {
          FunctionName = aws_lambda_function.terraform.arn
          "Payload.$"  = "$"
        }
        OutputPath = "$.Payload"
        End        = true
      }
      InvokeAWSLambda = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"
        Parameters = {
          FunctionName = aws_lambda_function.aws.arn
          "Payload.$"  = "$"
        }
        OutputPath = "$.Payload"
        End        = true
      }
      InvalidCourse = {
        Type  = "Fail"
        Error = "InvalidSelection"
        Cause = "The course provided does not match any valid options."
      }
    }
  }
}

resource "aws_sfn_state_machine" "sfn_demo" {
  name       = "${var.project_name}-sfn-course-selector"
  role_arn   = aws_iam_role.roles["stepfunction"].arn
  definition = jsonencode(local.sfn_definition)
}

