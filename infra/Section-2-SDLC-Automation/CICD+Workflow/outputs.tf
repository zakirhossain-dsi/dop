output "codecommit_repo_clone_url" {
  value = aws_codecommit_repository.code_repo.clone_url_http
}

output "codebuild_project_name" {
  value = aws_codebuild_project.build.name
}