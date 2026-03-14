output "endpoint_dns_name" {
  value = aws_vpc_endpoint.consumer_interface_endpoint.dns_entry[0].dns_name
}

output "endpoint_service_name" {
  value = aws_vpc_endpoint_service.endpoint_service.service_name
}

output "service_consumer_account_id" {
  value = data.aws_caller_identity.service_consumer_account.account_id
}