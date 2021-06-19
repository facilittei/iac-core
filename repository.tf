resource "aws_ecr_repository" "nginx" {
  name                 = "nginx"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "Nginx Container Registry"
    Project     = var.project
    Owner       = "Terraform"
    Environment = var.environment
  }
}

resource "aws_ecr_repository" "php-fpm" {
  name                 = "php-fpm"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "Nginx Container Registry"
    Project     = var.project
    Owner       = "Terraform"
    Environment = var.environment
  }
}
