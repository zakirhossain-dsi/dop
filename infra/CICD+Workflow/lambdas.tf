data "archive_file" "pr_trigger_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/pr_trigger/app.py"
  output_path = "${path.module}/lambda/pr_trigger/pr_trigger.zip"
}

data "archive_file" "build_result_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/build_result/app.py"
  output_path = "${path.module}/lambda/build_result/build_result.zip"
}

resource "aws_lambda_function" "pr_trigger" {
  function_name    = "${var.project_name}-pr-trigger"
  role             = aws_iam_role.roles["lambda"].arn
  handler          = var.python_fn_handler
  runtime          = var.python_version
  filename         = data.archive_file.pr_trigger_zip.output_path
  source_code_hash = data.archive_file.pr_trigger_zip.output_base64sha256

  environment {
    variables = {
      CODEBUILD_PROJECT = aws_codebuild_project.build.name
      REPO_NAME         = aws_codecommit_repository.code_repo.repository_name
    }
  }
}

resource "aws_lambda_function" "build_result" {
  function_name    = "${var.project_name}-build-result"
  role             = aws_iam_role.roles["lambda"].arn
  handler          = var.python_fn_handler
  runtime          = var.python_version
  filename         = data.archive_file.build_result_zip.output_path
  source_code_hash = data.archive_file.build_result_zip.output_base64sha256

  environment {
    variables = {
      REPO_NAME = aws_codecommit_repository.code_repo.repository_name
    }
  }
}