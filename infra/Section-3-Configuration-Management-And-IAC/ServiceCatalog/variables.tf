variable "region" { type = string }
variable "profile" { type = string }
variable "project_name" { type = string }
variable "env" { type = string }
variable "alice_console_password" {
  type      = string
  sensitive = true
}