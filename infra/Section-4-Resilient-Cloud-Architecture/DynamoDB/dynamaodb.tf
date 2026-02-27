# write tf config for DynamoDB
resource "aws_dynamodb_table" "user_data" {
  name         = "user_data"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userID"

  attribute {
    name = "userID"
    type = "S"
  }
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  tags = {
    Environment = "dev"
    Project     = var.project_name
  }
}