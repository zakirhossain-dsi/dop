resource "aws_cloudtrail" "management_trail" {
  name                          = "${var.project_name}-management-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "WriteOnly"
    include_management_events = true
  }
}