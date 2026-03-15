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

resource "aws_efs_access_point" "efs_access_points" {
  count          = 2
  file_system_id = aws_efs_file_system.shared_efs.id
  posix_user {
    uid = 1001 + count.index
    gid = 1001 + count.index
  }
  root_directory {
    path = "/app-${count.index + 1}-folder"
    creation_info {
      owner_uid   = 1001 + count.index
      owner_gid   = 1001 + count.index
      permissions = "0755"
    }
  }
  tags = {
    Name = "app-${count.index + 1}-folder"
  }
}