output "public_ec2_public_ip" {
  value = aws_instance.public_ec2.public_ip
}

output "private_ec2_private_ip" {
  value = aws_instance.private_ec2.private_ip
}

output "s3_bucket_name" {
  value = aws_s3_bucket.demo.bucket
}

output "s3_interface_endpoint_dns" {
  value = "https://bucket.${replace(aws_vpc_endpoint.s3_vpce.dns_entry[0].dns_name, "*.", "")}"
}