resource "aws_vpc" "account_b" {
  provider             = aws.account_b
  cidr_block           = var.account_b_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.default_tags, {
    Name = "Account-B-VPC"
  })
}

resource "aws_internet_gateway" "account_b" {
  provider = aws.account_b
  vpc_id   = aws_vpc.account_b.id
  tags = merge(var.default_tags, {
    Name = "Account-B-IGW"
  })
}

resource "aws_subnet" "account_b_public" {
  provider                = aws.account_b
  count                   = 2
  vpc_id                  = aws_vpc.account_b.id
  cidr_block              = var.account_b_public_subnet_cidrs[count.index]
  availability_zone       = local.account_b_az_names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "Account-B-Public-Subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "account_b_public" {
  provider = aws.account_b
  vpc_id   = aws_vpc.account_b.id
  tags = merge(var.default_tags, {
    Name = "Account-B-Public-Route-Table"
  })
}

resource "aws_route" "b_to_a" {
  provider               = aws.account_b
  route_table_id         = aws_route_table.account_b_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.account_b.id
}

resource "aws_route_table_association" "account_b_public" {
  provider       = aws.account_b
  count          = 2
  subnet_id      = aws_subnet.account_b_public[count.index].id
  route_table_id = aws_route_table.account_b_public.id
}