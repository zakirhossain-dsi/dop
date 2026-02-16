resource "aws_instance" "ec2" {
  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_instance_type
  user_data                   = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y python-pip
              EOF
  user_data_replace_on_change = true
  security_groups             = [aws_security_group.ssh_access.name]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  tags = {
    Name = "${var.project_name}-ec2"
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.roles["ec2"].name
}

resource "aws_security_group" "ssh_access" {
  name        = "${var.project_name}-ssh-sg"
  description = "Allow SSH access"
  tags = {
    Name = "${var.project_name}-ssh-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.ssh_access.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  cidr_ipv4         = var.cidr_ip_all
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ssh_access.id
  cidr_ipv4         = var.cidr_ip_all
  ip_protocol       = "-1" # semantically equivalent to all ports
}

