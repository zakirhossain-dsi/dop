data "archive_file" "validator_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/validator.py"
  output_path = "${path.module}/lambda/validator.zip"
}

data "archive_file" "notifier_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/request_approval.py"
  output_path = "${path.module}/lambda/request_approval.zip"
}

data "archive_file" "approver_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/approver.py"
  output_path = "${path.module}/lambda/approver.zip"
}

resource "aws_lambda_function" "validator" {
  function_name    = "${var.project_name}-validator"
  role             = aws_iam_role.iam_roles["lambda"].arn
  handler          = "validator.handler"
  runtime          = var.python_version
  filename         = data.archive_file.validator_zip.output_path
  source_code_hash = data.archive_file.validator_zip.output_base64sha256

  environment {
    variables = {
      ADMIN_POLICY_ARN = var.admin_access_policy_arn
    }
  }
}

resource "aws_lambda_function" "request_approval" {
  function_name    = "${var.project_name}-request-approval"
  role             = aws_iam_role.iam_roles["lambda_request_approval"].arn
  handler          = "request_approval.handler"
  runtime          = var.python_version
  filename         = data.archive_file.notifier_zip.output_path
  source_code_hash = data.archive_file.notifier_zip.output_base64sha256

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.approval_notifications.arn
    }
  }
}

resource "aws_lambda_function" "approver" {
  function_name    = "${var.project_name}-approver"
  role             = aws_iam_role.iam_roles["lambda_approver"].arn
  handler          = "approver.handler"
  runtime          = var.python_version
  filename         = data.archive_file.approver_zip.output_path
  source_code_hash = data.archive_file.approver_zip.output_base64sha256
}