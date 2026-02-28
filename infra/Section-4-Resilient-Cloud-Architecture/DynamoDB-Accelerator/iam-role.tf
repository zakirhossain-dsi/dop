data "aws_iam_policy_document" "dax_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["dax.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "dax_role" {
  name               = "${var.project_name}-dax-role"
  assume_role_policy = data.aws_iam_policy_document.dax_assume_role.json
  tags               = var.default_tags
}