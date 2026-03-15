data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "efs_client_role" {
  name               = "EC2EFSAccessRole"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
  tags               = var.default_tags
}