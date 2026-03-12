resource "aws_instance" "public_ec2" {
  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_instance_type
  subnet_id                   = data.aws_subnet.public_default.id
  vpc_security_group_ids      = [aws_security_group.public_ec2_sg.id]
  associate_public_ip_address = true
  key_name                    = var.ec2_key_name
  tags = {
    Name = "${var.project_name}-public-ec2"
  }
}

resource "aws_instance" "private_ec2" {
  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.private_ec2_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.private_ec2_profile.name
  associate_public_ip_address = false
  key_name                    = var.ec2_key_name
  tags = {
    Name = "${var.project_name}-private-ec2"
  }
}

resource "aws_iam_instance_profile" "private_ec2_profile" {
  name = "${var.project_name}-private-ec2-profile"
  role = aws_iam_role.private_ec2_role.name
}