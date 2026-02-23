resource "aws_iam_role_policy_attachment" "events_policy_attach" {
  policy_arn = aws_iam_policy.events_policy.arn
  role       = aws_iam_role.iam_roles["cw_events"].name
}

resource "aws_iam_role_policy_attachment" "sfn_policy_attach" {
  policy_arn = aws_iam_policy.sfn_policy.arn
  role       = aws_iam_role.iam_roles["state_machine"].name
}

resource "aws_iam_role_policy_attachment" "validator_lambda_attach" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.iam_roles["lambda"].name
}