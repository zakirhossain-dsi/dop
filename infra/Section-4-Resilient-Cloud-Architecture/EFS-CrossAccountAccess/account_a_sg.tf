resource "aws_security_group" "efs_sg" {
  provider    = aws.account_a
  name        = "efs-sg"
  description = "Allow NFS traffic from EC2 instances to EFS mount targets"
  vpc_id      = aws_vpc.account_a.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.account_b.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.default_tags, {
    Name = "account-a-efs-sg"
  })
}