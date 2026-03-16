resource "aws_iam_role" "efs_access_role" {
  provider = aws.account_a
  name     = "RoleAForEFS"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = aws_iam_role.ec2_role.arn
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "efs_access_role_policy" {
  provider = aws.account_a
  name     = "efs-client-access-policy"
  role     = aws_iam_role.efs_access_role.id

  # Read-write example.
  # For read-only, remove ClientWrite and keep only ClientMount.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "elasticfilesystem:ClientMount",
        "elasticfilesystem:ClientWrite",
        "elasticfilesystem:ClientRootAccess"
      ]
      Resource = aws_efs_file_system.shared.arn
    }]
  })
}