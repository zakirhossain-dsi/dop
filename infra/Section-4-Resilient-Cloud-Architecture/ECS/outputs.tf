output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_capacity_provider_name" {
  value = aws_ecs_capacity_provider.ec2.name
}
output "ecs_asg_name" {
  value = aws_autoscaling_group.ecs.name
}