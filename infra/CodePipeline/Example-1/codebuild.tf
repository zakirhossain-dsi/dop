resource "aws_codebuild_project" "maven_build" {
  name          = "${var.project_name}-build"
  description   = "Practicing codebuild project"
  build_timeout = 5
  service_role  = aws_iam_role.roles["codebuild"].arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

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
    type            = "GITHUB"
    location        = var.github_repo_https_url
    git_clone_depth = 1
    buildspec       = file("${path.module}/buildspec.yml")

    git_submodules_config {
      fetch_submodules = true
    }
  }
  source_version = "master"

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/${var.project_name}"
      stream_name = "maven"
    }
  }

}
