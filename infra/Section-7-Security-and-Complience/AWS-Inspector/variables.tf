variable "aws_region" { type = string }
variable "aws_profile" { type = string }
variable "ec2_ami_id" { type = string }
variable "ec2_instance_type" { type = string }
variable "default_tags" { type = map(string) }
variable "ecr_repo_name" { type = string }