resource "aws_security_group" "lb" {
  name   = "${lower(var.project)}-${var.environment}-lb"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Load Balancer"
    Project     = var.project
    Owner       = "Terraform"
    Environment = var.environment
  }
}

resource "aws_security_group" "api" {
  name   = "${lower(var.project)}-${var.environment}-api"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "API"
    Project     = var.project
    Owner       = "Terraform"
    Environment = var.environment
  }
}

resource "aws_security_group" "db" {
  name   = "${lower(var.project)}-${var.environment}-db"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.api.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Database"
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
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}

resource "aws_launch_configuration" "lc" {
  name          = "${lower(var.project)}-${var.environment}"
  image_id      = var.image_id
  instance_type = var.instance_type

  lifecycle {
    create_before_destroy = true
  }

  iam_instance_profile        = aws_iam_instance_profile.agent.name
  key_name                    = lower(var.project)
  security_groups             = [aws_security_group.api.id]
  associate_public_ip_address = false

  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo echo "ECS_CLUSTER=${lower(var.project)}" >> /etc/ecs/ecs.config
EOF
}

resource "aws_autoscaling_group" "asg" {
  name                      = "${lower(var.project)}-${var.environment}"
  launch_configuration      = aws_launch_configuration.lc.name
  min_size                  = 2
  max_size                  = 4
  desired_capacity          = 2
  health_check_type         = "ELB"
  health_check_grace_period = 300
  vpc_zone_identifier       = var.vpc_subnets_private

  target_group_arns     = [aws_lb_target_group.lb_target_group.arn]
  protect_from_scale_in = true

  lifecycle {
    create_before_destroy = true
  }
}
