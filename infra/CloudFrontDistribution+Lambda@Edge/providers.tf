terraform {
  required_providers {
    archive = {
      source = "hashicorp/archive"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

provider "aws" {
  alias   = "use1"
  region  = "us-east-1"
  profile = var.aws_profile
}