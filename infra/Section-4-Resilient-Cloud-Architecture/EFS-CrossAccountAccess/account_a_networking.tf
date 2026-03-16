resource "aws_vpc" "account_a" {
  provider             = aws.account_a
  cidr_block           = var.account_a_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.default_tags, {
    Name = "Account-A-VPC"
  })
}

resource "aws_internet_gateway" "account_a" {
  provider = aws.account_a
  vpc_id   = aws_vpc.account_a.id
  tags = merge(var.default_tags, {
    Name = "Account-A-IGW"
  })
}

resource "aws_subnet" "account_a_public" {
  provider                = aws.account_a
  count                   = 2
  vpc_id                  = aws_vpc.account_a.id
  cidr_block              = var.account_a_public_subnet_cidrs[count.index]
  availability_zone       = local.account_a_az_names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "Account-A-Public-Subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "account_a_public" {
  provider = aws.account_a
  vpc_id   = aws_vpc.account_a.id
  tags = merge(var.default_tags, {
    Name = "Account-A-Public-Route-Table"
  })
}

resource "aws_route" "account_a_default_inet" {
  provider               = aws.account_a
  route_table_id         = aws_route_table.account_a_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.account_a.id
}

resource "aws_route_table_association" "account_a_public" {
  provider       = aws.account_a
  count          = 2
  subnet_id      = aws_subnet.account_a_public[count.index].id
  route_table_id = aws_route_table.account_a_public.id
}