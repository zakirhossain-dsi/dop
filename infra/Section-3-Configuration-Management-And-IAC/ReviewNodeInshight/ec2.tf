resource "aws_instance" "dev" {
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  tags          = {
    Name = "${var.project_name}-app"
  }
}