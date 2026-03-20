data "aws_iam_policy_document" "vpc_flow_logs_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "vpc_flow_logs_policy" {
  name   = "vpc-flow-logs-policy"
  policy = data.aws_iam_policy_document.vpc_flow_logs_policy_doc.json
}