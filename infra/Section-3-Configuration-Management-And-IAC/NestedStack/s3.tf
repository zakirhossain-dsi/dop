resource "aws_s3_bucket" "central_repo" {
  bucket = "cf-central-repo"
}

resource "aws_s3_object" "s3_bucket_tmpl" {
  bucket = aws_s3_bucket.central_repo.bucket
  key    = "templates/s3_bucket.template"
  source = "${path.module}/s3_bucket.template"
  source_hash = filemd5("${path.module}/s3_bucket.template")
}