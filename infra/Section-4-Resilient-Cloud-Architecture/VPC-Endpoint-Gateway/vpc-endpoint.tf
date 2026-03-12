# -----------------------------
# S3 Gateway VPC Endpoint
# Associate it with the private route table
# AWS adds the needed route to the selected route table.
# -----------------------------
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = data.aws_vpc.default.id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.private.id
  ]
  tags = {
    Name = "${var.project_name}-s3-endpoint"
  }
}