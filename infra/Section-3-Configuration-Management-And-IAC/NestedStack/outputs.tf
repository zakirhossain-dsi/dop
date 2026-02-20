output "S3_Bucket_Template_URL" {
  description = "The URL of the S3 bucket template"
  value       = "https://${aws_s3_bucket.central_repo.bucket_regional_domain_name}/${aws_s3_object.s3_bucket_tmpl.key}"
}