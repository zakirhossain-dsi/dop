resource "aws_instance" "efs_clients" {
  ami                         = var.ec2_image_id
  instance_type               = var.ec2_instance_type
  subnet_id                   = var.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.efs_client_profile.name

  user_data = <<-EOF
                #!/bin/bash
                dnf update -y
                dnf install -y amazon-efs-utils nfs-utils
                mkdir -p /shared-storage
                EOF

  tags = merge({
    Name = "efs-client"
  }, var.default_tags)
  depends_on = [
    aws_efs_file_system.shared_efs,
    aws_efs_mount_target.mt
  ]
}

resource "aws_iam_instance_profile" "efs_client_profile" {
  name = "efs-client-profile"
  role = aws_iam_role.efs_client_role.name
}