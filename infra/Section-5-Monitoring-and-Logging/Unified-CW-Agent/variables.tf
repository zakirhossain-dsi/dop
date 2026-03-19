variable "aws_region" { type = string }
variable "aws_profile" { type = string }
variable "ami_id" { type = string }
variable "instance_type" { type = string }
variable "ssh_key_name" { type = string }
variable "all_ips_cidr" { type = string }
variable "default_tags" { type = map(string) }