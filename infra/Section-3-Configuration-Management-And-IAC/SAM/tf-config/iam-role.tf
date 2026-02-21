data "aws_iam_policy_document" "ec2_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "ec2_service_role1" {
  name               = "ec2-service-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust_policy.json
}