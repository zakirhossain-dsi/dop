data "aws_iam_policy_document" "file_gateway_s3_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetAcceleratedConfiguration",
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning",
      "s3:ListBucket",
      "s3:ListBucketVersions",
      "s3:ListBucketMultipartUploads"
    ]
    resources = [
      aws_s3_bucket.file_gateway.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectVersion",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      "${aws_s3_bucket.file_gateway.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "file_gateway_s3_policy" {
  name        = "${var.gateway_name}-s3-policy"
  description = "IAM policy for Storage Gateway to access S3 bucket"
  policy      = data.aws_iam_policy_document.file_gateway_s3_policy_document.json
}