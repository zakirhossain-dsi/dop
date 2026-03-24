output "bucket_name" {
  value = aws_s3_bucket.demo.bucket
}

output "sns_topic_arn" {
  value = aws_sns_topic.s3_events.arn
}