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

resource "aws_efs_file_system_policy" "efs_policy" {
  file_system_id = aws_efs_file_system.shared_efs.id
  policy         = data.aws_iam_policy_document.efs_access_policy.json
}

data "aws_iam_policy_document" "efs_access_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.efs_client_role.arn]
    }
    actions = ["elasticfilesystem:ClientMount"]
    resources = [
      aws_efs_file_system.shared_efs.arn
    ]
  }
}
