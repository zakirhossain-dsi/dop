resource "aws_autoscaling_group" "demo_asg" {
  name                      = var.project_name
  availability_zones        = var.availability_zones
  health_check_grace_period = 30
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  launch_template {
    id = aws_launch_template.security_template.id
    #        version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out-policy"
  autoscaling_group_name = aws_autoscaling_group.demo_asg.name
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "asg-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 25
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]
  alarm_description   = "Scale out when CPU is high"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.demo_asg.name
  }
}