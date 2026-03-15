resource "aws_efs_file_system" "shared_efs" {
  creation_token = "shared-efs-demo"
  tags = {
    Name = "shared-efs-demo"
  }
  encrypted = true
}

resource "aws_efs_mount_target" "mt" {
  for_each        = toset(var.public_subnet_ids)
  file_system_id  = aws_efs_file_system.shared_efs.id
  subnet_id       = each.value
  security_groups = [aws_security_group.efs_sg.id]
}