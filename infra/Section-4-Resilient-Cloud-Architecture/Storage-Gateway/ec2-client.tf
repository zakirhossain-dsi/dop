resource "aws_instance" "client" {
  ami                         = var.client_ami_id
  instance_type               = var.client_instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.client.id]
  associate_public_ip_address = true
  key_name                    = var.client_ssh_key_name
  user_data                   = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y nfs-utils
              mkdir -p ${var.mount_point}
              EOF
  tags = {
    Name = "nfs-client"
  }
}