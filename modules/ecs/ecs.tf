resource "aws_ecs_capacity_provider" "main" {
  name = "${lower(var.project)}-${var.environment}"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}

resource "aws_ecs_cluster" "main" {
  name               = "${lower(var.project)}-${var.environment}"
  capacity_providers = [aws_ecs_capacity_provider.main.name]

  tags = {
    Name        = "Cluster"
    Project     = var.project
    Owner       = "Terraform"
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "main" {
  family                = lower(var.project)
  container_definitions = file("${path.module}/task.definition.json")
  network_mode          = "bridge"

  tags = {
    Name        = "Task Definition"
    Project     = var.project
    Owner       = "Terraform"
    Environment = var.environment
  }
}

resource "aws_ecs_service" "api" {
  name            = "${lower(var.project)}-${var.environment}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 2

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    container_name   = "nginx"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  launch_type = "EC2"
  depends_on  = [aws_lb_listener.main]
}

resource "aws_cloudwatch_log_group" "logging" {
  name = "/ecs/api"

  tags = {
    Name        = "Cloudwatch log group"
    Project     = var.project
    Owner       = "Terraform"
    Environment = var.environment
  }
}
