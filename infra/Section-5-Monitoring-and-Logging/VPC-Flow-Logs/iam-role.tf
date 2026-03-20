data "aws_iam_policy_document" "assume_policy_doc" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "vpc_flow_logs_role" {
  name               = "vpc-flow-logs-role"
  assume_role_policy = data.aws_iam_policy_document.assume_policy_doc.json
}