variable "aws_region" { type = string }
variable "aws_profile" { type = string }
variable "ec2_ami_id" { type = string }
variable "ec2_instance_type" { type = string }
variable "default_tags" { type = map(string) }
variable "all_ips_cidr" { type = string }
variable "ssh_key_name" { type = string }