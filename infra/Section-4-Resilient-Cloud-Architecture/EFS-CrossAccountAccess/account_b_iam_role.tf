resource "aws_iam_role" "ec2_role" {
  provider = aws.account_b
  name     = "EC2EFSAccessRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "allow_assume_account_a_role" {
  provider = aws.account_b
  name     = "allow-assume-account-a-efs-role"
  role     = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "sts:AssumeRole"
      Resource = aws_iam_role.efs_access_role.arn
    }]
  })
}