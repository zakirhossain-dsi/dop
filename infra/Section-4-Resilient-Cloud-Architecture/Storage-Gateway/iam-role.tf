resource "aws_iam_role" "file_gateway" {
  name = "${var.gateway_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "storagegateway.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}