provider "aws" {
  region  = "ap-southeast-1"
  profile = "terraform-admin"
}

data "aws_iam_policy_document" "cf_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "cloudformation.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "cf_role" {
  name               = "cf-service-role"
  description        = "Allows CloudFormation to create and manage AWS stacks and resources on your behalf."
  assume_role_policy = data.aws_iam_policy_document.cf_policy_doc.json
}