data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "demo_task_definition" {
  family                   = "nginx-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"

  # The ecsTaskExecutionRole is the IAM role that ECS uses to run your task, especially during the startup phase of the container.
  # It allows ECS to perform actions on behalf of the task, but not inside your application code.
  # It allows the ECS agent / Fargate infrastructure to perform operations required to start the container.
  execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx:latest"
      essential = true
      portMappings = [
        {
          hostPort      = 80
          containerPort = 80
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      randomlyRootFilesystem = false
    }
  ])
}