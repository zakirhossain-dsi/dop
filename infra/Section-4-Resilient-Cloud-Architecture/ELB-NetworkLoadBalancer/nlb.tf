resource "aws_lb" "ssh_nlb" {
  name               = var.project_name
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.web_tier_sg.id]
  subnets            = var.subnet_ids
  tags               = var.default_tags
}

resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.ssh_nlb.arn
  port              = 22
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }
}