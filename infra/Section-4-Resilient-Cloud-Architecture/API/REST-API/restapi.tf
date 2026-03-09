resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "${var.project_name}-rest-api"
  description = "A simple REST API for demonstration purposes"
}

# GET method on root resource "/"
resource "aws_api_gateway_method" "get_root" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

# Lambda integration
resource "aws_api_gateway_integration" "get_root_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_rest_api.rest_api.root_resource_id
  http_method             = aws_api_gateway_method.get_root.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hello_world.invoke_arn
}

# Allow API Gateway to invoke Lambda
resource "aws_lambda_permission" "allow_apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/${aws_api_gateway_method.get_root.http_method}/"
}

# Deployment
resource "aws_api_gateway_deployment" "rest_api" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  depends_on = [
    aws_api_gateway_integration.get_root_lambda
  ]
}

# Stage
resource "aws_api_gateway_stage" "dev" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "dev"
  deployment_id = aws_api_gateway_deployment.rest_api.id
}