resource "aws_instance" "nginx_server" {
  ami                    = var.ec2_image_id
  instance_type          = var.instance_type
  tags                   = var.default_tags
  vpc_security_group_ids = [aws_security_group.nginx_server_sg.id]
  user_data              = <<-EOF
              #!/bin/bash
                dnf update -y
                dnf install -y nginx
                systemctl start nginx
                systemctl enable nginx
                echo "<h1>Welcome to Nginx on Amazon Linux 2023</h1>" > /usr/share/nginx/html/index.html
              EOF
}

resource "aws_security_group" "nginx_server_sg" {
  name        = "${var.project_name}-nginx-server-sg"
  description = "Security group for Nginx server"

  # Allow HTTP traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH traffic from anywhere (for management purposes)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0 # Allow all ports
    to_port     = 0 # Allow all ports
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}