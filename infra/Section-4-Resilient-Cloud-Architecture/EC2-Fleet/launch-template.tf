resource "aws_launch_template" "example" {
  name_prefix   = "demo-fleet-"
  image_id      = var.image_id
  instance_type = "t3.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2_fleet_sg.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              dnf install -y nginx
              systemctl enable nginx
              systemctl start nginx
              echo "Hello, World from EC2 Fleet!" > /var/www/html/index.html
              EOF
  )
}