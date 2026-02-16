resource "aws_codecommit_repository" "infra_repo" {
  repository_name = var.repo_name
  description     = "Repository for CICD and Workflow practising"
}