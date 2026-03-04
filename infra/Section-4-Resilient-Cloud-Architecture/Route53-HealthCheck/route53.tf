resource "aws_route53_health_check" "ngnix_health_check" {
  ip_address        = aws_instance.nginx_server.public_ip
  port              = 80
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 10
  type              = "HTTP"
  tags              = var.default_tags
}