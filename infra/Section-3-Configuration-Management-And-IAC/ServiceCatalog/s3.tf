locals {
  template_url = "https://s3.amazonaws.com/${aws_s3_bucket.template_bucket.bucket}/${aws_s3_object.dev_template.key}"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_s3_bucket" "template_bucket" {
  bucket        = "cf-templates-${data.aws_caller_identity.current.id}-${data.aws_region.current.region}"
  force_destroy = true
}

resource "aws_s3_object" "dev_template" {
  bucket      = aws_s3_bucket.template_bucket.id
  key         = "dev/ec2.yaml"
  source      = "${path.module}/templates/${var.env}/ec2.yaml"
  source_hash = filemd5("${path.module}/templates/${var.env}/ec2.yaml")
}