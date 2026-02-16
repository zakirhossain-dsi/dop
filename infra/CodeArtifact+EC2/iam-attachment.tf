resource "aws_iam_role_policy_attachment" "codeartifact_ec2_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeArtifactReadOnlyAccess"
  role       = aws_iam_role.roles["ec2"].name
}