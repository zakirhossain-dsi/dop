resource "aws_instance" "efs_clients" {
  count                       = 2
  ami                         = var.ec2_image_id
  instance_type               = var.ec2_instance_type
  subnet_id                   = var.public_subnet_ids[count.index]
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
                #!/bin/bash
                dnf update -y
                dnf install -y amazon-efs-utils nfs-utils
                mkdir -p /shared-storage
                EOF

  tags = merge({
    Name = "efs-client-${count.index + 1}"
  }, var.default_tags)
  depends_on = [
    aws_efs_file_system.shared_efs,
    aws_efs_mount_target.mt
  ]
}