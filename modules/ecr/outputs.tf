output "ecr_repo_arn" {
  value       = aws_ecr_repository.ecr_repo.arn
  description = "ECR repository ARN"
}

output "ecr_repo_url" {
  value       = aws_ecr_repository.ecr_repo.repository_url
  description = "ECR repository URL"
}
