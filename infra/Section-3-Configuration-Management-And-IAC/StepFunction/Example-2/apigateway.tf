data "aws_region" "current" {}

locals {
  approval_api_base_url = "https://${aws_apigatewayv2_api.approval_api.id}.execute-api.${data.aws_region.current.region}.amazonaws.com"
}

resource "aws_apigatewayv2_api" "approval_api" {
  name          = "${var.project_name}-approval-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "approval_integration" {
  api_id                 = aws_apigatewayv2_api.approval_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.lambda["approver"].invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "approval_route" {
  api_id    = aws_apigatewayv2_api.approval_api.id
  route_key = "GET /approve"
  target    = "integrations/${aws_apigatewayv2_integration.approval_integration.id}"
}

resource "aws_apigatewayv2_route" "reject_route" {
  api_id    = aws_apigatewayv2_api.approval_api.id
  route_key = "GET /reject"
  target    = "integrations/${aws_apigatewayv2_integration.approval_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.approval_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "allow_apigw_invoke_approver" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda["approver"].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.approval_api.execution_arn}/*/*"
}