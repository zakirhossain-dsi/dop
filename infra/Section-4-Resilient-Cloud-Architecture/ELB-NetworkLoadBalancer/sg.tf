resource "aws_security_group" "web_tier_sg" {
  name        = "${var.project_name}-web-tier-sg"
  description = "Security group for Nginx server and ALB"

  # Allow HTTP traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic_cidr]
  }

  # Allow SSH traffic from anywhere (for management purposes)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic_cidr]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0 # Allow all ports
    to_port     = 0 # Allow all ports
    protocol    = "-1"
    cidr_blocks = [var.all_traffic_cidr]
  }
}