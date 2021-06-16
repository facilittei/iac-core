module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.1.0"
  name    = "${lower(var.project)}-${var.environment}"
  cidr    = var.cidr
  azs     = var.azs

  private_subnets = [
    cidrsubnet(var.cidr, 8, 1),
    cidrsubnet(var.cidr, 8, 2)
  ]

  public_subnets = [
    cidrsubnet(var.cidr, 8, 11),
    cidrsubnet(var.cidr, 8, 12)
  ]

  database_subnets = [
    cidrsubnet(var.cidr, 8, 21),
    cidrsubnet(var.cidr, 8, 22)
  ]

  create_database_subnet_group           = var.environment != "prod" ? true : false
  create_database_subnet_route_table     = var.environment != "prod" ? true : false
  create_database_internet_gateway_route = var.environment != "prod" ? true : false

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true

  tags = {
    Name        = "VPC"
    Project     = var.project
    Owner       = "Terraform"
    Environment = var.environment
  }
}

resource "aws_security_group" "lb" {
  name   = "${lower(var.project)}-${var.environment}-lb"
  vpc_id = module.vpc.vpc_id

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
  vpc_id = module.vpc.vpc_id

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
  vpc_id = module.vpc.vpc_id

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
