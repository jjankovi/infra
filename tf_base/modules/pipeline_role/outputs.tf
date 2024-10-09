output "pipeline_role_arn" {
  value       = aws_iam_role.pipeline_role.arn
  description = "ARN of the IAM role used by CICD Pipeline."
}

output "pipeline_role_name" {
  value       = aws_iam_role.pipeline_role.name
  description = "The name of the IAM role used by CICD Pipeline."
}