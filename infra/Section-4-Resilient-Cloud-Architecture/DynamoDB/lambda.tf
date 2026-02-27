data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/dynamo-db-stream-listener.py"
  output_path = "${path.module}/lambda/dynamo-db-stream-listener.zip"
}

resource "aws_lambda_function" "dynamo_db_stream_listener" {
  function_name    = "dynamo_stream_to_cloudwatch_logs"
  role             = aws_iam_role.roles["lambda"].arn
  handler          = "dynamo-db-stream-listener.handler"
  runtime          = var.python_version
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  tags = merge(var.default_tags, {
    Environment = var.environment
  })
}

resource "aws_lambda_event_source_mapping" "dynamo_db_stream_listener_mapping" {
  event_source_arn  = aws_dynamodb_table.user_data.stream_arn
  function_name     = aws_lambda_function.dynamo_db_stream_listener.arn
  starting_position = "TRIM_HORIZON"
  enabled           = true
}