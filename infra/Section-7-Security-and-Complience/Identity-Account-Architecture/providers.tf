provider "aws" {
  region  = var.ia_aws_region
  profile = var.ia_aws_profile
}

provider "aws" {
  alias   = "ia"
  region  = var.ia_aws_region
  profile = var.ia_aws_profile
}

provider "aws" {
  alias   = "sa"
  region  = var.sa_aws_region
  profile = var.sa_aws_profile
}