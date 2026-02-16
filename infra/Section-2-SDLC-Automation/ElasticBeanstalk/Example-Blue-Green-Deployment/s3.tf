resource "aws_s3_bucket" "eb_bundles" {
  bucket = "${var.project_name}-eb-bundles"
}

resource "aws_s3_object" "app_bundle" {
  bucket = aws_s3_bucket.eb_bundles.id
  key    = "releases/dop-${var.version_label}.zip"
  source = "${path.module}/base-eb-app.zip"
  etag   = filemd5("${path.module}/base-eb-app.zip")
}