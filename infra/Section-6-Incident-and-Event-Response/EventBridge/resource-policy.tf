resource "aws_cloudwatch_log_resource_policy" "eventbridge_to_cloudwatch" {
  policy_name = "eventbridge-to-cloudwatch-logs"
  policy_document = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "TrustEventsToPutLogsEvents"
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        },
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        "Resource" : "${aws_cloudwatch_log_group.production_ec2_stopped.arn}:*"
      }
    ]
  })
}