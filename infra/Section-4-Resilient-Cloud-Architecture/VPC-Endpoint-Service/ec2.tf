resource "aws_instance" "service_provider_ec2" {
  provider               = aws.service_provider
  ami                    = var.service_provider_ec2_ami_id
  instance_type          = var.service_provider_ec2_instance_type
  vpc_security_group_ids = [aws_security_group.service_provider_sg.id]
  user_data              = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Welcome to Nginx on Amazon Linux 2023</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = merge({
    Name = "Service Provider EC2 Instance"
  }, var.default_tags)
}

resource "aws_instance" "service_consumer_ec2" {
  provider               = aws.service_consumer
  ami                    = var.service_consumer_ec2_ami_id
  instance_type          = var.service_consumer_ec2_instance_type
  vpc_security_group_ids = [aws_security_group.service_consumer_sg.id]
  tags = merge({
    Name = "Service Consumer EC2 Instance"
  }, var.default_tags)
}