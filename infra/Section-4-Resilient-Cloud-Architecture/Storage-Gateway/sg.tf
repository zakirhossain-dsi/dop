resource "aws_security_group" "gateway" {
  name        = "${var.gateway_name}-sg"
  description = "Security group for Storage Gateway"
  vpc_id      = data.aws_vpc.default.id

  # One-time gateway activation
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # NFS
  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.client.id]
  }

  # NFSv3 support
  ingress {
    from_port       = 111
    to_port         = 111
    protocol        = "tcp"
    security_groups = [aws_security_group.client.id]
  }

  ingress {
    from_port       = 111
    to_port         = 111
    protocol        = "udp"
    security_groups = [aws_security_group.client.id]
  }

  ingress {
    from_port       = 20048
    to_port         = 20048
    protocol        = "tcp"
    security_groups = [aws_security_group.client.id]
  }

  ingress {
    from_port       = 20048
    to_port         = 20048
    protocol        = "udp"
    security_groups = [aws_security_group.client.id]
  }

  # Allow SSH traffic from anywhere (for management purposes)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "client" {
  name        = "client-sg"
  description = "Security group for the client"

  # Allow SSH traffic from anywhere (for management purposes)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}