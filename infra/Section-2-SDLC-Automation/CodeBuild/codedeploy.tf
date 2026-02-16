resource "aws_codedeploy_app" "codedeploy_app" {
  name             = "${var.project_name}-codedeploy-app"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "codedeploy_deployment_group" {
  app_name              = aws_codedeploy_app.codedeploy_app.name
  deployment_group_name = "${var.project_name}-codedeploy-deployment-group"
  service_role_arn      = aws_iam_role.roles["codedeploy"].arn
  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "${var.project_name}-app"
    }
  }
}