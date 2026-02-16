resource "aws_instance" "app" {
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  tags = {
    Name = "${var.project_name}-app-${count.index + 1}"
  }
  count = 2
}