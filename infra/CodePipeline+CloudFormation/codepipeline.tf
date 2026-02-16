resource "aws_codepipeline" "codepipeline" {
  name     = "${var.project_name}-codepipeline"
  role_arn = aws_iam_role.roles["codepipeline"].arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.pipeline_artifacts.bucket
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        RepositoryName       = aws_codecommit_repository.infra_repo.repository_name
        BranchName           = var.branch_name
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "DeployCFN"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      version         = "1"
      input_artifacts = ["source_output"]
      configuration = {
        ActionMode   = "CREATE_UPDATE"
        StackName    = "${var.project_name}-iam-user-stack"
        TemplatePath = "source_output::${var.cfn_template_path}"
        Capabilities = "CAPABILITY_NAMED_IAM"
        RoleArn      = aws_iam_role.roles["cloudformation"].arn
      }
    }
  }
}