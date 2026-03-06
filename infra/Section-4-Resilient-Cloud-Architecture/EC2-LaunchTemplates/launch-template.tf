resource "aws_launch_template" "security_template" {
  name_prefix   = "security-template-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  description   = "Security based launch template for EC2 instances"
  key_name      = "terraform-key"
  security_group_names = [var.sg_name]
  tags = merge(var.default_tags, {
    Name = "EC2-Launch-Template"
  })
  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.default_tags,
      {
        Name = "EC2-Launch-Template-Instance"
      }
    )
  }
}