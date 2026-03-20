resource "aws_cloudwatch_log_group" "vpc_flow_logs_group" {
  name              = "/aws/vpc/flow-logs/default-vpc"
  retention_in_days = 7
}