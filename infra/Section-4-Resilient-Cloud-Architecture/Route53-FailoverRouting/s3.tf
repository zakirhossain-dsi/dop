resource "aws_s3_bucket" "failover_bucket" {
  bucket = "demofailover.${var.domain_name}"
  tags   = var.default_tags
}

resource "aws_s3_bucket_website_configuration" "failover_bucket_website" {
  bucket = aws_s3_bucket.failover_bucket.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket                  = aws_s3_bucket.failover_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.failover_bucket.id
  key          = "index.html"
  source       = "${path.module}/site/index.html"
  source_hash  = filemd5("${path.module}/site/index.html")
  content_type = "text/html"
}

data "aws_iam_policy_document" "s3_public_read" {
  statement {
    sid       = "PublicReadGetObject"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.failover_bucket.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "site_policy" {
  bucket     = aws_s3_bucket.failover_bucket.id
  policy     = data.aws_iam_policy_document.s3_public_read.json
  depends_on = [aws_s3_bucket_public_access_block.site]
}
