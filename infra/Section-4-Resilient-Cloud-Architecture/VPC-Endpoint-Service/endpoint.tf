resource "aws_vpc_endpoint" "consumer_interface_endpoint" {
  provider           = aws.service_consumer
  service_name       = aws_vpc_endpoint_service.endpoint_service.service_name
  vpc_endpoint_type  = "Interface"
  vpc_id             = var.service_consumer_vpc_id
  subnet_ids         = var.service_consumer_subnet_ids
  security_group_ids = [aws_security_group.endpoint_sg.id]
  tags = merge({
    Name = "Consumer Interface Endpoint"
  }, var.default_tags)
}