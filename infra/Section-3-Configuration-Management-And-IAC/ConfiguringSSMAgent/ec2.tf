resource "aws_instance" "web_app" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.web_app_profile.name
  tags = {
    Name = "${var.project_name}-web-app"
  }
}

resource "aws_iam_instance_profile" "web_app_profile" {
  name = "${var.project_name}-web-app-profile"
  role = aws_iam_role.roles["ec2"].name
}
