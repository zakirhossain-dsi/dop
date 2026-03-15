resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow SSH and outbound traffic for EC2 instances"

  # Allow SSH access
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

resource "aws_security_group" "efs_sg" {
  name        = "efs-mount-target-sg"
  description = "Allow NFS traffic from EC2 instances to EFS mount targets"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_ips_cidr]
  }
}