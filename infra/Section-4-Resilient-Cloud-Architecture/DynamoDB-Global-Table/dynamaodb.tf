# write tf config for DynamoDB
resource "aws_dynamodb_table" "user_data" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userID"

  attribute {
    name = "userID"
    type = "S"
  }
  # Required for Global Tables
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  replica {
    region_name = var.dynamodb_replica_region
  }
  tags = var.default_tags
}