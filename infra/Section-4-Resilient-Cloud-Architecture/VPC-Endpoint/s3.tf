resource "aws_s3_bucket" "demo" {
  bucket = "${var.project_name}-private-s3-demo-${data.aws_caller_identity.current.account_id}"
}
resource "aws_s3_object" "demo_file" {
  bucket       = aws_s3_bucket.demo.id
  key          = "hello.txt"
  content      = "Hello, World!"
  content_type = "text/plain"
}