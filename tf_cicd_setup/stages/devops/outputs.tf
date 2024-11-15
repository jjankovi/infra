output "ci_ecr_repo_arn" {
  value       = module.cicd_ecr_repo.ecr_repo_arn
  description = "ARN of ECR repository which contains CI docker images"
}
