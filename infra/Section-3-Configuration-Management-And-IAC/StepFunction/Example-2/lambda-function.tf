data "archive_file" "validator_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/validator.py"
  output_path = "${path.module}/lambda/validator.zip"
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