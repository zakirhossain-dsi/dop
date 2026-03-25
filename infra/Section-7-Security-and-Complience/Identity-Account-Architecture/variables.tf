variable "ia_aws_region" { type = string }
variable "ia_aws_profile" { type = string }
variable "ia_pgp_key" {
  description = "PGP public key for encrypting the initial console password"
  type        = string
}

variable "sa_aws_region" { type = string }
variable "sa_aws_profile" { type = string }