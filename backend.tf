resource "aws_s3_bucket" "terraform_state" {
  bucket = "facilittei-terraform-state"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name    = "S3 Bucket Terraform State"
    Project = var.project
    Owner   = "Terraform"
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "facilittei-terraform-state"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name    = "DynamoDB Table Terraform State Lock"
    Project = var.project
    Owner   = "Terraform"
  }
}

terraform {
  backend "s3" {
    bucket = "facilittei-terraform-state"
    key    = "facilittei.terraform.tfstate"
    region = "us-east-1"
  }
}