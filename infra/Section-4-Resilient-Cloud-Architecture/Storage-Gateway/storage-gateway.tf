resource "aws_storagegateway_gateway" "file_gateway" {
  gateway_name     = "s3-storage-gateway"
  gateway_timezone = "GMT+8:00"
  gateway_type     = "FILE_S3"
  activation_key   = var.activation_key
}

data "aws_storagegateway_local_disk" "cache_disk" {
  gateway_arn = aws_storagegateway_gateway.file_gateway.arn
  disk_path   = "/dev/nvme1n1"
}

resource "aws_storagegateway_cache" "cache" {
  gateway_arn = aws_storagegateway_gateway.file_gateway.arn
  disk_id     = data.aws_storagegateway_local_disk.cache_disk.id
  depends_on  = [aws_storagegateway_gateway.file_gateway]
}

resource "aws_storagegateway_nfs_file_share" "nfs_share" {
  client_list           = [data.aws_vpc.default.cidr_block]
  gateway_arn           = aws_storagegateway_gateway.file_gateway.arn
  location_arn          = aws_s3_bucket.file_gateway.arn
  role_arn              = aws_iam_role.file_gateway.arn
  default_storage_class = "S3_STANDARD"
  squash                = "RootSquash"
  depends_on = [
    aws_storagegateway_cache.cache,
    aws_iam_role_policy_attachment.file_gateway_s3_policy_attachment
  ]
}