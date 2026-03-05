output "alb_dns_name" {
  value = "http://${aws_lb.ssh_nlb.dns_name}"
}

output "ec2_instance_public_ip" {
  value = aws_instance.nginx_server.public_ip
}