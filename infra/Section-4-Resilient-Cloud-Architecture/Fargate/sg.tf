resource "aws_security_group" "ecs_service_sg" {
  name        = "${var.project_name}-service-sg"
  description = "Security group for ECS service"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.all_ips_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_ips_cidr]
  }
}
