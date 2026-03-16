data "aws_iam_policy_document" "efs_policy_doc" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.efs_access_role.arn]
    }
    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
      "elasticfilesystem:ClientRootAccess"
    ]
    resources = [aws_efs_file_system.shared.arn]
  }
}

resource "aws_efs_file_system_policy" "efs_policy" {
  provider       = aws.account_a
  file_system_id = aws_efs_file_system.shared.id
  policy         = data.aws_iam_policy_document.efs_policy_doc.json
}