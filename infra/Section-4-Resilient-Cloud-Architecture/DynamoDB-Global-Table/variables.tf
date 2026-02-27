variable "region" {
  description = "AWS region to deploy resources"
  type        = string
}
variable "profile" {
  description = "AWS CLI profile to use for authentication"
  type        = string
}
variable "table_name" {
  description = "Name of the DynamoDB table to create"
  type        = string
}
variable "project_name" {
  description = "Name of the project for tagging resources"
  type        = string
}
variable "python_version" {
  description = "Python runtime version for Lambda function"
  type        = string
}
variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default = {
    Owner   = "zakir.mbstu.ict07@gmail.com"
    Project = "dynamodb-global-table-demo"
  }
}
variable "dynamodb_replica_region" {
  description = "AWS region for DynamoDB global table replica"
  type        = string
}
variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table to create"
  type        = string
}
