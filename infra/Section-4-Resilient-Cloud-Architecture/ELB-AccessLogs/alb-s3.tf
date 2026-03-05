data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "elb_access_logs_bucket" {
  bucket        = "${var.project_name}-logs-${data.aws_caller_identity.current.account_id}"
  tags          = var.default_tags
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "lb_logs" {
  bucket                  = aws_s3_bucket.elb_access_logs_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "lg_logs_policy" {
  statement {
    sid    = "AllowELBLogDelivery"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.elb_access_logs_bucket.arn}/alb/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.elb_access_logs_bucket.id
  policy = data.aws_iam_policy_document.lg_logs_policy.json
}