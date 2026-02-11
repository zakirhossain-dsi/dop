variable "aws_region" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "project_name" {
  type = string
}

variable "eb_policies" {
  type = list(string)
}

variable "ec2_policies" {
  type = list(string)
}

variable "platform_arn" {
  type = string
}
variable "cname_prefix" {
  type = string
}
variable "tier" {
  type = string
}