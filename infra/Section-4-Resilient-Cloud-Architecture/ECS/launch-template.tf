# Latest ECS-optimized Amazon Linux 2 AMI
data "aws_ssm_parameter" "ecs_al2_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}

resource "aws_launch_template" "ecs" {
  name_prefix            = "${var.project_name}-lt-"
  image_id               = data.aws_ssm_parameter.ecs_al2_ami.value
  instance_type          = var.instance_type
  key_name               = "terraform-key"
  vpc_security_group_ids = [aws_security_group.ecs_ec2_sg.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }
  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config
              echo ECS_ENABLE_CONTAINER_METADATA=true >> /etc/ecs/ecs.config
              yum update -y
              yum install -y install ec2-instance-connect
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-instance"
    }
  }

  tags = {
    Name = "${var.project_name}-launch-template"
  }
}