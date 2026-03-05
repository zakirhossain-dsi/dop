resource "aws_instance" "nginx_server" {
  ami                    = var.ec2_image_id
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.web_tier_sg.id]
  tags                   = merge(var.default_tags, { "Name" = "${var.project_name}-nginx-server" })
  subnet_id              = var.subnet_ids[0]
  key_name               = var.ec2_key_pair_name
  user_data              = <<-EOF
              #!/bin/bash
                dnf update -y
                dnf install -y nginx
                systemctl start nginx
                systemctl enable nginx
                echo "<h1>Welcome to Nginx on Amazon Linux 2023</h1>" > /usr/share/nginx/html/index.html
              EOF
}