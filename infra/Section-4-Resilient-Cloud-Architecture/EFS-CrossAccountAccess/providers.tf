provider "aws" {
  region  = var.account_a_aws_region
  profile = var.account_a_aws_profile
}

provider "aws" {
  alias   = "account_a"
  region  = var.account_a_aws_region
  profile = var.account_a_aws_profile
}

provider "aws" {
  alias   = "account_b"
  region  = var.account_b_aws_region
  profile = var.account_b_aws_profile
}