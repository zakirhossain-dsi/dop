resource "aws_sns_topic" "approval_notifications" {
  name = "${var.project_name}-approval-notifications"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.approval_notifications.arn
  protocol  = "email"
  endpoint  = var.approval_email
}