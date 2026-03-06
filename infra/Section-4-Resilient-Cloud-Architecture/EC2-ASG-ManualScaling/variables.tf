variable "aws_region" { type = string }
variable "aws_profile" { type = string }
variable "project_name" { type = string }
variable "ami_id" { type = string }
variable "instance_type" { type = string }
variable "all_ips_cidr" { type = string }
variable "availability_zones" { type = set(string) }
variable "default_tags" {
  type = map(string)
  default = {
    Project = "demo-launch-template"
    Owner   = "zakir.mbstu.ict07@gmail.com"
  }
}