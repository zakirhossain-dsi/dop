resource "aws_security_group" "public_ec2_sg" {
  name        = "${var.project_name}-public-ec2-sg"
  description = "Security group for public EC2 instances"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow SSH access from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.all_ips_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_ips_cidr]
  }
}

resource "aws_security_group" "private_ec2_sg" {
  name        = "${var.project_name}-private-ec2-sg"
  description = "Security group for private EC2 instances"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "Allow SSH access from public EC2 instances"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2_sg.id]
  }

  egress {
    description = "HTTPS to S3 interface endpoint"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.all_ips_cidr]
  }
}

resource "aws_security_group" "s3_vpce" {
  name        = "${var.project_name}-s3-interface-endpoint-sg"
  description = "Security group for S3 VPC interface endpoint"
  vpc_id      = data.aws_vpc.default.id

  # Allow all http traffic
  ingress {
    description = "HTTPS traffic from private EC2"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.private_ec2_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_ips_cidr]
  }
}