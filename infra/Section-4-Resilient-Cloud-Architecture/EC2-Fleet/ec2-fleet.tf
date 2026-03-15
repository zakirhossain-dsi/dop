resource "aws_ec2_fleet" "example" {
  type                = "maintain"
  terminate_instances = true

  target_capacity_specification {
    total_target_capacity        = 4
    default_target_capacity_type = "spot"
    on_demand_target_capacity    = 2
    spot_target_capacity         = 2
  }

  launch_template_config {
    launch_template_specification {
      launch_template_id = aws_launch_template.example.id
      version            = "$Latest"
    }

    override {
      instance_type     = "t3.micro"
      weighted_capacity = 1
    }

    override {
      instance_type     = "t3.small"
      weighted_capacity = 1
    }
    override {
      instance_type     = "t3.large"
      weighted_capacity = 1
    }
  }
}