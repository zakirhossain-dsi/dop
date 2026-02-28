data "aws_iam_policy_document" "dax_access" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:ConditionCheckItem",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
      "dynamodb:DescribeTable",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:DescribeContinuousBackups",
      "dynamodb:DescribeContributorInsights",
      "dynamodb:DescribeKinesisStreamingDestination",
      "dynamodb:DescribeStream",
      "dynamodb:ListStreams"
    ]
    resources = [aws_dynamodb_table.user_data.arn]
  }
}

resource "aws_iam_policy" "dax_access_policy" {
  name   = "${var.project_name}-dax-access-policy"
  policy = data.aws_iam_policy_document.dax_access.json
  tags   = var.default_tags
}