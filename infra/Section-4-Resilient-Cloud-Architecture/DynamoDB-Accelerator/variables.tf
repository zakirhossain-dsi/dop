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
    Project = "dynamodb-accelerator-demo"
  }
}
variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table to create"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC to deploy resources in"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to deploy resources in"
  type        = list(string)
}

variable "app_cidrs" {
  description = "List of CIDR blocks for application access"
  type        = list(string)
}

variable "dax_node_type" {
  description = "Node type for the DAX cluster"
  type        = string
}
variable "dax_replication_factor" {
  description = "Replication factor for the DAX cluster"
  type        = number
}
