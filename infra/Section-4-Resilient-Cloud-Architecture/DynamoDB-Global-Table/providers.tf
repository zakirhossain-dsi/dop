provider "aws" {
  region  = var.region
  profile = var.profile
}

provider "aws" {
  alias   = "replica"
  region  = var.dynamodb_replica_region
  profile = var.profile
}