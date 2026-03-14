resource "aws_security_group" "service_provider_sg" {
  name        = "service-provider-ec2-sg"
  description = "Security group for EC2 instance in service provider account"
  provider    = aws.service_provider

  # Allow HTTP traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.all_ips_cidr]
  }

  # Allow SSH traffic from anywhere (for management purposes)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.all_ips_cidr]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_ips_cidr]
  }
}

resource "aws_security_group" "service_consumer_sg" {
  name        = "service-consumer-ec2-sg"
  description = "Security group for EC2 instance in service consumer account"
  provider    = aws.service_consumer

  # Allow HTTP traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.all_ips_cidr]
  }

  # Allow SSH traffic from anywhere (for management purposes)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.all_ips_cidr]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_ips_cidr]
  }
}

resource "aws_security_group" "endpoint_sg" {
  name        = "service-consumer-endpoint-sg"
  description = "Security group for VPC Endpoint in service consumer account"
  provider    = aws.service_consumer

  # Allow HTTP traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.all_ips_cidr]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_ips_cidr]
  }
}