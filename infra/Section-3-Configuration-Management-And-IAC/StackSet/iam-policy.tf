data "aws_iam_policy_document" "cf_admin_assume_policy_document" {
  statement {
    effect   = "Allow"
    actions  = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::*:role/AWSCloudFormationStackSetExecutionRole"]
  }
}

resource "aws_iam_policy" "cf_admin_assume_policy" {
  name   = "AssumeRolePolicy"
  policy = data.aws_iam_policy_document.cf_admin_assume_policy_document.json
}