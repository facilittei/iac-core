output "bucket_backend" {
  description = "The S3 infrastructure state ID."
  value       = aws_s3_bucket.terraform_state.id
}

output "dynamodb_backend" {
  description = "The DynamoDB table infrastructure state lock ID."
  value       = aws_dynamodb_table.terraform_state_lock.id
}

output "ecr_repository_id" {
  description = "The ECR container image registry iD."
  value       = aws_ecr_repository.images.registry_id
}

output "ecr_repository_url" {
  description = "The ECR container image registry URL."
  value       = aws_ecr_repository.images.repository_url
}

output "vpc_id" {
  description = "The VPC ID provisioned."
  value       = module.vpc.vpc_id
}

output "vpc_subnets_private" {
  value = module.vpc.private_subnets
}

output "vpc_subnets_public" {
  value = module.vpc.public_subnets
}

output "vpc_igw_id" {
  value = module.vpc.igw_id
}

output "vpc_nat_ids" {
  value = module.vpc.nat_ids
}
