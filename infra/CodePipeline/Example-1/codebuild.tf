resource "aws_codebuild_project" "maven_build" {
  name          = "${var.project_name}-build"
  description   = "Practicing codebuild project"
  build_timeout = 5
  service_role  = aws_iam_role.roles["codebuild"].arn

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "ARTIFACT_BUCKET"
      value = aws_s3_bucket.artifacts.bucket
    }
    environment_variable {
      name  = "ARTIFACT_PREFIX"
      value = var.artifact_prefix
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/buildspec.yml")
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/${var.project_name}"
      stream_name = "maven"
    }
  }
}
