output "gateway_ec2_pubic_ip" {
  value = aws_instance.gateway_host.public_ip
}

output "gateway_arn" {
  value = aws_storagegateway_gateway.file_gateway.arn
}

output "nfs_mount_command" {
  value = "sudo mount -t nfs -o nolock,hard ${aws_instance.gateway_host.private_ip}:/${aws_s3_bucket.file_gateway.bucket} ${var.mount_point}"
}

output "bucket_name" {
  value = aws_s3_bucket.file_gateway.bucket
}

output "gateway_public_ip" {
  value = aws_instance.gateway_host.public_ip
}