output "pipeline_deployer_role_arn" {
  value       = aws_iam_role.pipeline_deployer_role.arn
  description = "ARN of the IAM role used by CICD Pipeline to deploy application."
}

output "pipeline_deployer_role_name" {
  value       = aws_iam_role.pipeline_deployer_role.name
  description = "The name of the IAM role used by CICD Pipeline to deploy application."
}