resource "aws_iam_role_policy_attachment" "private_ec2_s3_access_attachment" {
  policy_arn = aws_iam_policy.private_ec2_s3_access_policy.arn
  role       = aws_iam_role.private_ec2_role.name
}