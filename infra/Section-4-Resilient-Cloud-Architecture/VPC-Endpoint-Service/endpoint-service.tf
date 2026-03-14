resource "aws_vpc_endpoint_service" "endpoint_service" {
  provider                   = aws.service_provider
  acceptance_required        = true
  network_load_balancer_arns = [aws_lb.service_provider_nlb.arn]
  supported_ip_address_types = ["ipv4"]
  allowed_principals = [
    "arn:aws:iam::${data.aws_caller_identity.service_consumer_account.account_id}:root"
  ]
  tags = merge({
    Name = "service provider"
  }, var.default_tags)
}