resource "aws_cloudwatch_log_group" "ssm_agent_logs" {
  name              = "/aws/ssm/ec2/server-logs"
  retention_in_days = 7
  tags = {
    Name = var.project_name
  }
}