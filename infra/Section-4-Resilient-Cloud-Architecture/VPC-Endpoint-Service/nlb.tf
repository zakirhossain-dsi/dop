resource "aws_lb_target_group" "nlb_tg" {
  name        = "service-provider-tg"
  provider    = aws.service_provider
  protocol    = "TCP"
  port        = 80
  target_type = "instance"
  vpc_id      = var.service_provider_vpc_id

  health_check {
    protocol            = "TCP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  tags = var.default_tags
}

resource "aws_lb_target_group_attachment" "nginx_attachment" {
  provider         = aws.service_provider
  target_group_arn = aws_lb_target_group.nlb_tg.arn
  target_id        = aws_instance.service_provider_ec2.id
  port             = 80
}

resource "aws_lb" "service_provider_nlb" {
  name               = "service-provider-nlb"
  provider           = aws.service_provider
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.service_provider_sg.id]
  subnets            = var.service_provider_subnet_ids
  tags               = var.default_tags
}

resource "aws_lb_listener" "nlb_listener" {
  provider          = aws.service_provider
  load_balancer_arn = aws_lb.service_provider_nlb.arn
  port              = 80
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}