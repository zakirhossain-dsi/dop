resource "aws_instance" "app_server" {
  ami                         = var.ec2_ami
  instance_type               = var.ec2_image_type
  subnet_id                   = aws_subnet.public["customer"].id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.app_server_sg.id]
}

resource "aws_security_group" "app_server_sg" {
  name   = "app-server-sg"
  vpc_id = aws_vpc.project.id

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