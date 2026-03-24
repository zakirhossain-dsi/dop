resource "aws_cloudwatch_log_group" "production_ec2_stopped" {
  name              = "/aws/events/production-ec2-stopped"
  retention_in_days = 7
}