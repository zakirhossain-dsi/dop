resource "aws_instance" "app_server" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]
  iam_instance_profile = aws_iam_instance_profile.cw_agent_profile.name
  tags                 = merge(var.default_tags, { Name = "App-Server" })
}

resource "aws_iam_instance_profile" "cw_agent_profile" {
  name = "cw-agent-profile"
  role = aws_iam_role.roles["ec2-cloudwatch"].name
}