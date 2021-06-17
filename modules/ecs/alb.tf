resource "aws_lb" "lb" {
  name               = "${lower(var.project)}-${var.environment}"
  load_balancer_type = "application"
  internal           = false
  subnets            = var.vpc_subnets_public
  security_groups    = [aws_security_group.lb.id]

  tags = {
    Name        = "Load Balancer"
    Project     = var.project
    Owner       = "Terraform"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  name        = "${lower(var.project)}-${var.environment}"
  port        = "80"
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/healthcheck"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }

  tags = {
    Name        = "Load Balancer Target Group"
    Project     = var.project
    Owner       = "Terraform"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }

  tags = {
    Name        = "Load Balancer Listener main"
    Project     = var.project
    Owner       = "Terraform"
    Environment = var.environment
  }
}
