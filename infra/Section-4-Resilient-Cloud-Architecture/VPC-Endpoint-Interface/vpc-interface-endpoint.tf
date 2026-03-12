resource "aws_vpc_endpoint" "s3_vpce" {
  vpc_id              = data.aws_vpc.default.id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private.id]
  security_group_ids  = [aws_security_group.s3_vpce.id]
  private_dns_enabled = false
  tags = {
    Name = "${var.project_name}-interface-s3"
  }
}