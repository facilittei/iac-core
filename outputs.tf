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
