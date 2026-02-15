resource "aws_codebuild_project" "build" {
  name         = "${var.project_name}-build"
  service_role = aws_iam_role.roles["codebuild"].arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = false

    /*    environment_variable {
      name  = "REPO_NAME"
      value = aws_codecommit_repository.code_repo.repository_name
    }

    environment_variable {
      name  = "BRANCH_NAME"
      value = var.branch_name
    }*/
  }

  source {
    type      = "CODECOMMIT"
    location  = aws_codecommit_repository.code_repo.clone_url_http
    buildspec = file("${path.module}/buildspec.yml")
  }
}