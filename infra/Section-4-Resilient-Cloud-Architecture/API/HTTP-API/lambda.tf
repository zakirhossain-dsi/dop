data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/index.py"

  output_path = "${path.module}/lambda/index.zip"
}

resource "aws_lambda_function" "hello_world" {
  function_name    = "hello_world_lambda"
  role             = aws_iam_role.roles["lambda"].arn
  handler          = "index.handler"
  runtime          = var.python_version
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}