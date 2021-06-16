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
