data "aws_iam_policy_document" "events_policy_doc" {
  statement {
    actions   = ["states:StartExecution"]
    resources = [aws_sfn_state_machine.security_workflow.arn]
  }
}

data "aws_iam_policy_document" "sfn_policy_doc" {
  statement {
    actions = ["lambda:InvokeFunction"]
    resources = [
      aws_lambda_function.lambda["validator"].arn,
      aws_lambda_function.lambda["request_approval"].arn,
      aws_lambda_function.lambda["remediator"].arn
    ]
  }
}

data "aws_iam_policy_document" "lambda_policy_doc" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "lambda_request_approval_policy_doc" {
  statement {
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.approval_notifications.arn]
  }
}

resource "aws_iam_policy" "events_policy" {
  name   = "${var.project_name}-events-policy"
  policy = data.aws_iam_policy_document.events_policy_doc.json
}

resource "aws_iam_policy" "sfn_policy" {
  name   = "${var.project_name}-sfn-policy"
  policy = data.aws_iam_policy_document.sfn_policy_doc.json
}

resource "aws_iam_policy" "lambda_policy" {
  policy = data.aws_iam_policy_document.lambda_policy_doc.json
  name   = "${var.project_name}-lambda-policy"
}

resource "aws_iam_policy" "lambda_request_approval_policy" {
  name   = "${var.project_name}-lambda-request-approval-policy"
  policy = data.aws_iam_policy_document.lambda_request_approval_policy_doc.json
}

resource "aws_iam_policy" "lambda_approver_callback_policy" {
  name        = "${var.project_name}-lambda-approver-callback"
  description = "Allow approver lambda to resume Step Functions waiting tasks"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["states:SendTaskSuccess", "states:SendTaskFailure"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_remediator_policy" {
  name        = "${var.project_name}-lambda-remediator-callback"
  description = "Allow remediator lambda to detach only the admin policy from the student user"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["iam:DetachUserPolicy"]
        Resource = aws_iam_user.student.arn
        Condition = {
          StringEquals = {
            "iam:PolicyARN" = var.admin_access_policy_arn
          }
        }
      }
    ]
  })
}