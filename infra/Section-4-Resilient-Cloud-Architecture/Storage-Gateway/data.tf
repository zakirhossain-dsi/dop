data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "storage_gateway_ami" {
  name = "/aws/service/storagegateway/ami/FILE_S3/latest"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_storagegateway_local_disk" "cache_disk" {
  gateway_arn = aws_storagegateway_gateway.file_gateway.arn
  disk_path   = "/dev/nvme1n1"
}

#resource "time_sleep" "wait_for_gateway_boot" {
#  depends_on      = [aws_instance.gateway_host, aws_volume_attachment.cache]
#  create_duration = "180s"
#}

#data "http" "activation_key" {
#  depends_on = [time_sleep.wait_for_gateway_boot]
#  url        = "http://${aws_instance.gateway_host.public_ip}?activationRegion=${var.aws_region}&no_redirect"
#}
