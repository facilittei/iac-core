resource "aws_ecr_repository" "images" {
  name                 = lower(var.project)
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "Container Registry"
    Project     = var.project
    Owner       = "Terraform"
    Environment = var.environment
  }
}
