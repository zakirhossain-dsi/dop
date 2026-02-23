data "archive_file" "lf_terraform_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/lf_terraform.py"
  output_path = "${path.module}/lambda/lf_terraform.zip"
}

resource "aws_lambda_function" "terraform" {
  function_name    = "${var.project_name}-lf-terraform"
  role             = aws_iam_role.roles["lambda"].arn
  handler          = "lf_terraform.handler"
  runtime          = var.python_version
  filename         = data.archive_file.lf_terraform_zip.output_path
  source_code_hash = data.archive_file.lf_terraform_zip.output_base64sha256

  environment {
    variables = {

    }
  }
}

data "archive_file" "lf_aws_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/lf_aws.py"
  output_path = "${path.module}/lambda/lf_aws.zip"
}

resource "aws_lambda_function" "aws" {
  function_name    = "${var.project_name}-lf-aws"
  role             = aws_iam_role.roles["lambda"].arn
  handler          = "lf_aws.handler"
  runtime          = var.python_version
  filename         = data.archive_file.lf_aws_zip.output_path
  source_code_hash = data.archive_file.lf_aws_zip.output_base64sha256

  environment {
    variables = {

    }
  }
}