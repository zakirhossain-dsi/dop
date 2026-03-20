resource "aws_flow_log" "vpc" {
  vpc_id               = data.aws_vpc.default.id
  traffic_type         = "ALL"
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs_group.arn
  iam_role_arn         = aws_iam_role.vpc_flow_logs_role.arn
  tags                 = merge({
    Name = "default-vpc-flow-logs"
  }, var.default_tags)
}