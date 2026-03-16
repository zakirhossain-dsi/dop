resource "aws_security_group" "ec2_sg" {
  provider    = aws.account_b
  name        = "ec2-sg"
  description = "EC2 security group"
  vpc_id      = aws_vpc.account_b.id

  # Allow SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_ingress_cidr]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.default_tags, {
    Name = "account-b-ec2-sg"
  })
}