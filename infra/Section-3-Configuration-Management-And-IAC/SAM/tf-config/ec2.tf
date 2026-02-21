provider "aws" {
  region  = "ap-southeast-1"
  profile = "terraform-admin"
}

resource "aws_instance" "app_server" {
  ami                    = "ami-039a8ebebdd2a1def"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ssh_access.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  user_data              = <<-EOF
      #!/bin/bash
      set -euxo pipefail
      dnf update -y
      dnf install -y gcc gcc-c++ make zip ca-certificates groff python3 python3-pip python3-setuptools python3-devel unzip nodejs
      curl -Lo sam-installation.zip https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
      unzip sam-installation.zip -d /tmp/sam-installation
      /tmp/sam-installation/install
      dnf install -y docker || true
      systemctl enable --now docker || true
    EOF
}

resource "aws_security_group" "ssh_access" {
  name = "allow-ssh"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.ssh_access.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ssh_access.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_service_role1.name
}