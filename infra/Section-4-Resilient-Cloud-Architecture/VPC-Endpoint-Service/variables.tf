variable "aws_region" { type = string }
variable "all_ips_cidr" { type = string }
variable "default_tags" { type = map(string) }

variable "service_provider_aws_profile" { type = string }
variable "service_provider_ec2_ami_id" { type = string }
variable "service_provider_ec2_instance_type" { type = string }
variable "service_provider_vpc_id" { type = string }
variable "service_provider_subnet_ids" { type = set(string) }

variable "service_consumer_aws_profile" { type = string }
variable "service_consumer_ec2_ami_id" { type = string }
variable "service_consumer_ec2_instance_type" { type = string }
variable "service_consumer_vpc_id" { type = string }
variable "service_consumer_subnet_ids" { type = set(string) }