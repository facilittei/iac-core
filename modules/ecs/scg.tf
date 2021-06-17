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