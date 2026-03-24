variable "aws_region" { type = string }
variable "aws_profile" { type = string }
variable "project_name" { type = string }
variable "db_username" {
  type      = string
  sensitive = true
}
variable "db_password" {
  type      = string
  sensitive = true
}
variable "default_tags" { type = map(string) }