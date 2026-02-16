resource "aws_iam_role_policy_attachment" "codebuild_attach" {
  role       = aws_iam_role.roles["codebuild"].id
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

resource "aws_iam_role_policy_attachment" "ec2_attach" {
  role       = aws_iam_role.roles["ec2"].id
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "codedeploy_attach" {
  role       = aws_iam_role.roles["codedeploy"].id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}