resource "aws_instance" "app_server" {
  ami                    = var.ec2_ami_id
  instance_type          = var.ec2_instance_type
  tags                   = var.default_tags
  key_name = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]
}