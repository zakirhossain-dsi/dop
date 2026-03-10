data "aws_iam_policy_document" "ecr_access_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:CompleteLayerUpload",
      "ecr:GetAuthorizationToken",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecr_access_policy" {
  name   = "${var.project_name}-ecr-access-policy"
  policy = data.aws_iam_policy_document.ecr_access_policy_doc.json
}