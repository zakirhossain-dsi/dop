resource "aws_instance" "servers" {
  for_each      = local.ec2_instances
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  tags = {
    Name = each.value.name
    Team = each.value.team
  }
}