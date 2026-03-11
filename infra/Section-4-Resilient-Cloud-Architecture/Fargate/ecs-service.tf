resource "aws_ecs_service" "nginx" {
  name                          = "nginx-task-definition-service"
  cluster                       = aws_ecs_cluster.main.id
  task_definition               = aws_ecs_task_definition.demo_task_definition.arn
  scheduling_strategy           = "REPLICA"
  desired_count                 = 1
  availability_zone_rebalancing = "ENABLED"
  launch_type                   = "FARGATE"

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = true
  }

  deployment_controller {
    type = "ECS"
  }

  enable_ecs_managed_tags = false
  propagate_tags          = "NONE"
}