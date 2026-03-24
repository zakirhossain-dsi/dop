resource "aws_sns_topic" "s3_events" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_policy" "allow_s3" {
  arn = aws_sns_topic.s3_events.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowS3Publish"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.s3_events.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" : aws_s3_bucket.demo.arn
          }
          StringEquals = {
            "aws:SourceAccount" : data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.s3_events.arn
  endpoint  = var.notification_email
  protocol  = "email"
  lifecycle {
    prevent_destroy = true
  }
}