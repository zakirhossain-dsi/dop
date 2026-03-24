resource "aws_cloudwatch_event_rule" "app_server_stopped" {
  name        = "app-server-stopped"
  description = "Rule to trigger when the app server is stopped"
  event_pattern = jsonencode({
    "source" : ["aws.ec2"],
    "detail-type" : ["EC2 Instance State-change Notification"],
    "detail" : {
      "state" : ["stopped"],
      # "instance-id": [aws_instance.app_server.id]
    }
  })
}

resource "aws_cloudwatch_event_target" "notify_cloudwatch_log" {
  rule = aws_cloudwatch_event_rule.app_server_stopped.name
  arn  = aws_cloudwatch_log_group.production_ec2_stopped.arn
}