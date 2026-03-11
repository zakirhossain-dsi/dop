resource "aws_autoscaling_group" "ecs" {
  name                  = "${var.project_name}-asg"
  min_size              = 1
  max_size              = 3
  desired_capacity      = 1
  vpc_zone_identifier   = var.public_subnet_ids
  protect_from_scale_in = false
  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "${var.project_name}-asg-instance"
    propagate_at_launch = true
  }
  tag {
    key                 = "AmazonECSManaged"
    value               = "true"
    propagate_at_launch = true
  }
}