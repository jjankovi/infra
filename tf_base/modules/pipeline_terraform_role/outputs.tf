output "pipeline_terraform_role_arn" {
  value       = aws_iam_role.pipeline_terraform_role.arn
  description = "ARN of the IAM role used by CICD Pipeline Terraform to provision resources."
}

output "pipeline_terraform_role_name" {
  value       = aws_iam_role.pipeline_terraform_role.name
  description = "The name of the IAM role used by CICD Pipeline Terraform to provision resources."
}