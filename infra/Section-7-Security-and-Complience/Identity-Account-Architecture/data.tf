data "aws_caller_identity" "ia" {
  provider = aws.ia
}

data "aws_caller_identity" "sa" {
  provider = aws.sa
}