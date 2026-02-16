resource "aws_s3_bucket" "cf_source_bucket" {
  bucket = "${var.project_name}-cf-source"
}

resource "aws_s3_bucket_public_access_block" "cf_source_block_public" {
  bucket                  = aws_s3_bucket.cf_source_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "s3_obj_sky" {
  bucket = aws_s3_bucket.cf_source_bucket.id
  key    = "images/sky.jpg"
  source = "${path.module}/assets/images/sky.jpg"
}

resource "aws_s3_object" "s3_obj_ocean" {
  bucket = aws_s3_bucket.cf_source_bucket.id
  key    = "images/ocean.jpg"
  source = "${path.module}/assets/images/ocean.jpg"
}