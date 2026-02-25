resource "aws_instance" "app_server" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]
  user_data              = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y mariadb105
    mysql --version > /var/log/mysql-client-version.txt
  EOF
  tags = {
    Name    = "${var.project_name}-app-server"
    Project = var.project_name
  }
}

resource "aws_security_group" "app_server_sg" {
  name        = "${var.project_name}-ec2-sg"
  description = "Allow SSH access"
  tags = {
    Project = var.project_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_access_rule" {
  security_group_id = aws_security_group.app_server_sg.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  cidr_ipv4         = var.all_ipv4
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.app_server_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = var.all_ipv4
}