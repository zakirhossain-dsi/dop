# write tf config for DynamoDB
resource "aws_dynamodb_table" "user_data" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userID"

  attribute {
    name = "userID"
    type = "S"
  }
  tags = var.default_tags
}

