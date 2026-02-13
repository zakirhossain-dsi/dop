data "archive_file" "lambda_edge_zip" {
  type        = "zip"
  source_file = "${path.module}/assets/lambda/index.js"
  output_path = "${path.module}/assets/lambda/lambda_edge_function.zip"
}

resource "aws_lambda_function" "lambda_edge_function" {
  provider         = aws.use1
  function_name    = "${var.project_name}-lambda-edge"
  filename         = data.archive_file.lambda_edge_zip.output_path
  role             = aws_iam_role.roles["lambda"].arn
  handler          = var.lambda_edge_handler
  runtime          = var.lambda_edge_runtime
  publish          = true
  source_code_hash = data.archive_file.lambda_edge_zip.output_base64sha256
}