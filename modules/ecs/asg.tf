data "aws_ami" "machine" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami*amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon", "self"]
}

resource "aws_launch_configuration" "lc" {
  name          = "${lower(var.project)}-${var.environment}"
  image_id      = data.aws_ami.machine.id
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
sudo echo "ECS_CLUSTER=${lower(var.project)}-${var.environment}" >> /etc/ecs/ecs.config
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
