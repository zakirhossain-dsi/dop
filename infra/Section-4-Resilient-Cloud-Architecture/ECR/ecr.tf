resource "aws_ecr_repository" "demo_repository" {
  name                 = "demo-ecr-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "demo-ecr-repo"
  }
  force_delete = true
}
