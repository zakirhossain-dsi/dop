provider "aws" {
  alias   = "service_consumer"
  region  = var.aws_region
  profile = var.service_consumer_aws_profile
}

provider "aws" {
  alias   = "service_provider"
  region  = var.aws_region
  profile = var.service_provider_aws_profile
}