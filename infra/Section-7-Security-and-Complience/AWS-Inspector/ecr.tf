resource "aws_ecr_repository" "private_app" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
  tags = merge(
    {
      "Name" = "Private-Repo"
    },
  var.default_tags)
}