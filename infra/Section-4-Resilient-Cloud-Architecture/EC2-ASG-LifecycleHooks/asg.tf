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

resource "aws_autoscaling_lifecycle_hook" "log_backup" {
  name                   = "${var.project_name}-log-backup"
  autoscaling_group_name = aws_autoscaling_group.demo_asg.name
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"
  default_result         = "CONTINUE"
  heartbeat_timeout      = 3600
}