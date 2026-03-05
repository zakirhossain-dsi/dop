output "alb_dns_name" {
  value = "http://${aws_lb.nginx_alb.dns_name}"
}