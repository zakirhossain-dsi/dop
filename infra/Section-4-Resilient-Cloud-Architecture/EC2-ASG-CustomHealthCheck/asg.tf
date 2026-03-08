resource "aws_autoscaling_group" "demo_asg" {
  name = var.project_name
  launch_template {
    id = aws_launch_template.security_template.id
    #        version = "$Latest"
  }
  availability_zones        = var.availability_zones
  health_check_grace_period = 30
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
}