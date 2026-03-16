resource "aws_vpc_peering_connection" "a_to_b" {
  provider      = aws.account_a
  vpc_id        = aws_vpc.account_a.id
  peer_vpc_id   = aws_vpc.account_b.id
  peer_owner_id = data.aws_caller_identity.account_b.account_id
  auto_accept   = false
  tags = merge(var.default_tags, {
    Name = "account-a-to-account-b-peering"
  })
}

resource "aws_vpc_peering_connection_accepter" "b_accepts" {
  provider                  = aws.account_b
  vpc_peering_connection_id = aws_vpc_peering_connection.a_to_b.id
  auto_accept               = true
  tags = merge(var.default_tags, {
    Name = "account-b-accepts-peering"
  })
}

resource "aws_route" "account_a_to_b" {
  provider                  = aws.account_a
  route_table_id            = aws_route_table.account_a_public.id
  destination_cidr_block    = aws_vpc.account_b.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.a_to_b.id
}

resource "aws_route" "account_b_to_a" {
  provider                  = aws.account_b
  route_table_id            = aws_route_table.account_b_public.id
  destination_cidr_block    = aws_vpc.account_a.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.a_to_b.id
}
