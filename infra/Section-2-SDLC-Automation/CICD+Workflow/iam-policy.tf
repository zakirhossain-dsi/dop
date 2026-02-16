data "aws_iam_policy_document" "codebuild_policy_doc" {
  statement {
    resources = ["*"]
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }

  statement {
    resources = [aws_codecommit_repository.code_repo.arn]
    actions = [
      "codecommit:GitPull",
      "codecommit:GetRepository",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:BatchGet*",
      "codecommit:Get*",
      "codecommit:List*"
    ]
  }
}

data "aws_iam_policy_document" "lambda_policy_doc" {
  statement {
    resources = ["*"]
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }
  statement {
    resources = [aws_codebuild_project.build.arn]
    actions = [
      "codebuild:StartBuild",
      "codebuild:BatchGetBuilds"
    ]
  }

  statement {
    resources = [aws_codecommit_repository.code_repo.arn]
    actions = [
      "codecommit:GetPullRequest",
      "codecommit:PostCommentForPullRequest"
    ]
  }
}

resource "aws_iam_policy" "codebuild_policy" {
  name   = "${var.project_name}-codebuild-policy"
  policy = data.aws_iam_policy_document.codebuild_policy_doc.json
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "${var.project_name}-lambda-policy"
  policy = data.aws_iam_policy_document.lambda_policy_doc.json
}