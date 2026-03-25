resource "aws_instance" "app_server" {
  ami                    = var.ec2_ami_id
  instance_type          = var.ec2_instance_type
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]
  tags = merge(
    {
      "Name" = "App-Server"
    },
  var.default_tags)
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_ecr_role.name
}

resource "aws_security_group" "app_server_sg" {
  name        = "app-server-sg"
  description = "Allow SSH and HTTP access"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}