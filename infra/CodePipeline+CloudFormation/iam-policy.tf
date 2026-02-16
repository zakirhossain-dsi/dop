data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    actions = [
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:UploadArchive",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:CancelUploadArchive"
    ]
    resources = [aws_codecommit_repository.infra_repo.arn]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning",
    ]
    resources = [
      aws_s3_bucket.pipeline_artifacts.arn,
      "${aws_s3_bucket.pipeline_artifacts.arn}/*"
    ]
  }

  statement {
    actions = [
      "cloudformation:CreateStack",
      "cloudformation:UpdateStack",
      "cloudformation:CreateChangeSet",
      "cloudformation:ExecuteChangeSet",
      "cloudformation:DeleteStack",
      "cloudformation:Describe*",
      "cloudformation:Get*",
      "cloudformation:List*"
    ]
    resources = ["*"]
  }

  statement {
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.roles["cloudformation"].arn]
  }
}

data "aws_iam_policy_document" "cfn_exec_policy" {
  statement {
    actions = [
      "iam:CreateUser",
      "iam:DeleteUser",
      "iam:GetUser",
      "iam:UpdateUser",
      "iam:List*",
      "iam:TagUser",
      "iam:UntagUser"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "codepipeline_policy" {
  name   = "${var.project_name}-codepipeline-policy"
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}

resource "aws_iam_policy" "cfn_exec_policy" {
  name   = "${var.project_name}-cfn-exec-policy"
  policy = data.aws_iam_policy_document.cfn_exec_policy.json
}