data "aws_iam_policy_document" "cf_bucket_doc" {
  statement {
    sid    = "AllowCloudFrontRead"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.cf_source_bucket.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cdn.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "cf_bucket_policy" {
  bucket = aws_s3_bucket.cf_source_bucket.id
  policy = data.aws_iam_policy_document.cf_bucket_doc.json
}