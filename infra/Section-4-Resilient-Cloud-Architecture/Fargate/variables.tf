variable "aws_region" { type = string }
variable "aws_profile" { type = string }
variable "project_name" { type = string }
variable "vpc_id" { type = string }
variable "all_ips_cidr" { type = string }
variable "public_subnet_ids" { type = list(string) }