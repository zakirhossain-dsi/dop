data "aws_caller_identity" "service_consumer_account" {
  provider = aws.service_consumer
}