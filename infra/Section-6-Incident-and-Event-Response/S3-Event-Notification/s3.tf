data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "demo" {
  bucket = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.demo.id
  topic {
    topic_arn = aws_sns_topic.s3_events.arn
    events = [
      "s3:ObjectCreated:*"
    ]
  }

  depends_on = [aws_sns_topic_policy.allow_s3]
}