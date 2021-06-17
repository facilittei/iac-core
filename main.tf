terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "ecs" {
  source              = "./modules/ecs"
  project             = var.project
  environment         = var.environment
  image_id            = var.image_id
  instance_type       = var.instance_type
  vpc_id              = module.vpc.vpc_id
  vpc_subnets_private = module.vpc.private_subnets
  vpc_subnets_public  = module.vpc.public_subnets
}
