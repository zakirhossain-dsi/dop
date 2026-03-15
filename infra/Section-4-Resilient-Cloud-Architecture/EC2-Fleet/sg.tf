resource "aws_security_group" "ec2_fleet_sg" {
  name        = "${var.project_name}-fleet-sg"
  description = "Security group for EC2 Fleet instances"

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