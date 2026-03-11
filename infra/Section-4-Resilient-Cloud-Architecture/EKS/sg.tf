resource "aws_security_group" "eks_sg" {
  name        = "${var.project_name}-sg"
  description = "Security group for EKS resources"
  vpc_id      = var.vpc_id

  # Allow all inbound traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_ips_cidr]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

resource "aws_security_group" "eks_node_group_ssh" {
  name   = "${var.project_name}-eks-ssh-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.all_ips_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_ips_cidr]
  }
}