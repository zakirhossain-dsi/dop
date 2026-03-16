variable "account_a_aws_region" { type = string }
variable "account_a_aws_profile" { type = string }
variable "account_a_vpc_cidr" { type = string }
variable "account_a_public_subnet_cidrs" { type = list(string) }

variable "account_b_aws_region" { type = string }
variable "account_b_aws_profile" { type = string }
variable "account_b_vpc_cidr" { type = string }
variable "account_b_public_subnet_cidrs" { type = list(string) }
variable "account_b_ec2_image_id" { type = string }
variable "account_b_ec2_instance_type" { type = string }

variable "ssh_ingress_cidr" { type = string }
variable "default_tags" { type = map(string) }