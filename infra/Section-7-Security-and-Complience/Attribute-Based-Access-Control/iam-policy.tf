data "aws_iam_policy_document" "ec2_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:StartInstances",
      "ec2:StopInstances"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/Team"
      values = [
        "$${aws:PrincipalTag/Team}"
      ]
    }
  }
}

resource "aws_iam_policy" "ec2_policy" {
  name   = "EC2AccessPolicy"
  policy = data.aws_iam_policy_document.ec2_policy_doc.json
}