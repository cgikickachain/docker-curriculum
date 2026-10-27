# Same as: ECS → Clusters → Create cluster
resource "aws_ecs_cluster" "catapp" {
  name = "catAppCluster-tf"
}

# Reuse the existing task execution role (what you picked in the console)
data "aws_iam_role" "task_execution" {
  name = "ecsTaskExecutionRole"
}

# Same as: ECS → Task definitions → Create new task definition
resource "aws_ecs_task_definition" "catapp" {
  family                   = "ECSCatAppDemoTask-tf"
  requires_compatibilities = ["EC2"]  # Launch type: Amazon EC2 instances
  network_mode             = "bridge" # Network mode: bridge
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = data.aws_iam_role.task_execution.arn

  # The "Container - 1" section of the console form
  container_definitions = jsonencode([
    {
      name      = "CatAppContainer"
      image     = "${aws_ecr_repository.catapp.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.container_port # Flask listens here
          hostPort      = var.host_port      # opened in the security group
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# Keeps 1 copy of the task running (the console's "Run task", but self-healing)
resource "aws_ecs_service" "catapp" {
  name            = "${var.project}-service"
  cluster         = aws_ecs_cluster.catapp.id
  task_definition = aws_ecs_task_definition.catapp.arn
  desired_count   = var.desired_count
  launch_type     = "EC2" # "Launch type: EC2"

  # Only one instance + a fixed host port (8888): stop the old task before
  # starting the new one on updates, otherwise they'd fight over port 8888
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100
}
