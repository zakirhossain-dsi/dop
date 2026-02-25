variable "region" { type = string }
variable "profile" { type = string }
variable "project_name" { type = string }
variable "image_id" { type = string }
variable "instance_type" { type = string }
variable "all_ipv4" { type = string }
variable "db_engine" { type = string }
variable "db_engine_version" { type = string }
variable "db_master_username" { type = string }
variable "db_master_password" {
  type      = string
  sensitive = true
}
variable "db_name" { type = string }
variable "db_instance_class" { type = string }
variable "db_cluster_instance_class" { type = string }
