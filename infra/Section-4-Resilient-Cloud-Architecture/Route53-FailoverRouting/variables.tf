variable "region" { type = string }
variable "profile" { type = string }
variable "project_name" { type = string }
variable "ec2_image_id" { type = string }
variable "instance_type" { type = string }
variable "domain_name" { type = string }
variable "vpc_id" { type = string }
variable "default_tags" {
  type = map(string)
  default = {
    "Project" = "route53-healthcheck"
    "Owner"   = "zakir.mbstu.ict07@gmail.com"
  }
}