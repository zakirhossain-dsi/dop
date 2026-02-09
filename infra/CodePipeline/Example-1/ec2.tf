resource "aws_instance" "app_server" {
  ami                  = var.ami_id
  instance_type        = var.ec2_instance_type
  key_name             = "terraform-key"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [
    aws_security_group.ssh_access.id
  ]

  user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail

    yum update -y
    yum install -y ruby wget

    cd /home/ec2-user
    wget https://aws-codedeploy-${var.aws_region}.s3.${var.aws_region}.amazonaws.com/latest/install
    chmod +x ./install
    ./install auto

    systemctl enable codedeploy-agent
    systemctl start codedeploy-agent

    # Install Java
    dnf update -y
    dnf install -y java-17-amazon-corretto
  EOF

  tags = {
    Name = "${var.project_name}-app"
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
  cidr_ipv4         = var.ssh_ip_cidr
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ssh_access.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}