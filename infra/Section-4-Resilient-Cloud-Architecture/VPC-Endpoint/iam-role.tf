data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "private_ec2_role" {
  name               = "${var.project_name}-private-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}