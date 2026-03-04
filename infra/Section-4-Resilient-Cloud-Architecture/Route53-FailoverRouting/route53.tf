resource "aws_route53_zone" "private_zone" {
  name = var.domain_name
  vpc {
    vpc_region = var.region
    vpc_id     = var.vpc_id
  }
  tags = var.default_tags
}

resource "aws_route53_record" "primary" {
  name            = "demofailover"
  type            = "A"
  zone_id         = aws_route53_zone.private_zone.zone_id
  set_identifier  = "EC2 Instance"
  ttl             = 60
  records         = [aws_instance.nginx_server.public_ip]
  health_check_id = aws_route53_health_check.ngnix_health_check.id
  failover_routing_policy {
    type = "PRIMARY"
  }
}

resource "aws_route53_record" "secondary" {
  name           = "demofailover"
  zone_id        = aws_route53_zone.private_zone.zone_id
  type           = "A"
  set_identifier = "S3 Bucket"
  failover_routing_policy {
    type = "SECONDARY"
  }
  alias {
    name                   = aws_s3_bucket_website_configuration.failover_bucket_website.website_domain
    zone_id                = aws_s3_bucket.failover_bucket.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_health_check" "ngnix_health_check" {
  ip_address        = aws_instance.nginx_server.public_ip
  port              = 80
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 10
  type              = "HTTP"
  tags              = var.default_tags
}