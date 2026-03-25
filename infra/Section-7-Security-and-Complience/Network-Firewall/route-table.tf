// Customer subnet route table
resource "aws_route_table" "customer_subnet_rt" {
  vpc_id = aws_vpc.project.id
  tags = merge({
    "Name" = "customer-route-table"
  }, var.default_tags)

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = local.firewall_endpoints_by_az[aws_subnet.public["firewall"].availability_zone]
  }
}

resource "aws_route_table_association" "customer_subnet_rt_association" {
  route_table_id = aws_route_table.customer_subnet_rt.id
  subnet_id      = aws_subnet.public["customer"].id
}

// Firewall subnet route table
resource "aws_route_table" "firewall_subnet_rt" {
  vpc_id = aws_vpc.project.id
  tags = merge({
    "Name" = "firewall-route-table"
  }, var.default_tags)

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
}

resource "aws_route_table_association" "firewall_subnet_rt_association" {
  subnet_id      = aws_subnet.public["firewall"].id
  route_table_id = aws_route_table.firewall_subnet_rt.id
}

// IGW route table
resource "aws_route_table" "igw_rt" {
  vpc_id = aws_vpc.project.id
  tags = merge({
    "Name" = "igw-route-table"
  }, var.default_tags)
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
  route {
    cidr_block      = "10.0.16.0/20"
    vpc_endpoint_id = local.firewall_endpoints_by_az[aws_subnet.public["firewall"].availability_zone]
  }
}

resource "aws_route_table_association" "igw_rt_association" {
  route_table_id = aws_route_table.igw_rt.id
  gateway_id     = aws_internet_gateway.ig.id
}