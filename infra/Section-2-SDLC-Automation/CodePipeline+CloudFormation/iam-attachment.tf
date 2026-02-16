resource "aws_iam_role_policy_attachment" "codepipeline_attachment" {
  role       = aws_iam_role.roles["codepipeline"].name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}

resource "aws_iam_role_policy_attachment" "cloudformation_attachment" {
  role       = aws_iam_role.roles["cloudformation"].name
  policy_arn = aws_iam_policy.cfn_exec_policy.arn
}
