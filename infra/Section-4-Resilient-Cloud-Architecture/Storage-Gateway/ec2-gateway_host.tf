resource "aws_instance" "gateway_host" {
  ami                         = data.aws_ssm_parameter.storage_gateway_ami.value
  instance_type               = var.gateway_host_instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.gateway.id]
  associate_public_ip_address = true
  root_block_device {
    volume_size = 80
    volume_type = "gp3"
  }
  tags = {
    Name = "${var.gateway_name}-host"
  }
}

resource "aws_ebs_volume" "cache" {
  availability_zone = aws_instance.gateway_host.availability_zone
  size              = 150
  type              = "gp3"

  tags = {
    Name = "${var.gateway_name}-cache"
  }
}

resource "aws_volume_attachment" "cache" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.cache.id
  instance_id = aws_instance.gateway_host.id
}