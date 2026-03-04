output "website_url" {
  value = aws_s3_bucket_website_configuration.failover_bucket_website.website_endpoint
}