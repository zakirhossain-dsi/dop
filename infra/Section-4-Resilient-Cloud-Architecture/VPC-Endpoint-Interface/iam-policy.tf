data "aws_iam_policy_document" "s3_access_document" {

  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.demo.arn]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.demo.arn}/*"]
  }
}

resource "aws_iam_policy" "private_ec2_s3_access_policy" {
  name   = "${var.project_name}-private-ec2-s3-access-policy"
  policy = data.aws_iam_policy_document.s3_access_document.json
}