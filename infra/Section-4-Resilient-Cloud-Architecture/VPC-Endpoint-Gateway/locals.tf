locals {
  public_subnet_id  = data.aws_subnets.default_vpc_subnets.ids[0]
  private_subnet_id = data.aws_subnets.default_vpc_subnets.ids[1]
}