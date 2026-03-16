resource "aws_efs_file_system" "shared" {
  provider       = aws.account_a
  creation_token = "cross-account-efs-demo"
  encrypted      = true
  tags = {
    Name = "cross-account-efs"
  }
}

resource "aws_efs_mount_target" "mt" {
  provider        = aws.account_a
  count           = 2
  file_system_id  = aws_efs_file_system.shared.id
  subnet_id       = aws_subnet.account_a_public[count.index].id
  security_groups = [aws_security_group.efs_sg.id]
}