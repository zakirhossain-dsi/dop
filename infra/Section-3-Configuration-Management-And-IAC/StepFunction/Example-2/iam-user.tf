resource "aws_iam_user" "student" {
  name = "${var.project_name}-student"
}