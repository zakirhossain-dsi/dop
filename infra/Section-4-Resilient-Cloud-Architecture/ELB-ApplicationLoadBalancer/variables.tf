variable "aws_region" { type = string }
variable "aws_profile" { type = string }
variable "ec2_instance_type" { type = string }
variable "ec2_image_id" { type = string }
variable "project_name" { type = string }
variable "all_traffic_cidr" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" {
  type = list(string)
}
variable "default_tags" {
  type = map(string)
  default = {
    "Project"     = "alb-demo"
    "Environment" = "demo"
    "Owner"       = "zakir.mbstu.ict07@gmail.com"
  }
}