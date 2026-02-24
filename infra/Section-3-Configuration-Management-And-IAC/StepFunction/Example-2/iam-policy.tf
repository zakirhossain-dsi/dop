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
      aws_lambda_function.validator.arn,
      aws_lambda_function.request_approval.arn
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