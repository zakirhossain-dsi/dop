data "aws_iam_policy_document" "cf_admin_policy_document" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["cloudformation.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cf_admin_role" {
  name               = "AWSCloudFormationStackSetAdministrationRole"
  assume_role_policy = data.aws_iam_policy_document.cf_admin_policy_document.json
}

data "aws_iam_policy_document" "cf_execution_policy_document" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:root"]
    }
  }
}

resource "aws_iam_role" "cf_execution_role" {
  name               = "AWSCloudFormationStackSetExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.cf_execution_policy_document.json
}