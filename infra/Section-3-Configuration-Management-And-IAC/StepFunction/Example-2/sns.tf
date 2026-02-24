resource "aws_sns_topic" "approval_notifications" {
  name = "${var.project_name}-approval-notifications"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.approval_notifications.arn
  protocol  = "email"
  endpoint  = var.approval_email
  lifecycle {
    prevent_destroy = true
  }
}