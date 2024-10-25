output "cicd_iac_role_arn" {
  value       = aws_iam_role.cicd_role.arn
  description = "ARN of the IAM role used by CICD Pipeline to deploy AWS resources."
}

output "cicd_iac_role_name" {
  value       = aws_iam_role.cicd_role.name
  description = "The name of the IAM role used by CICD Pipeline to deploy AWS resources."
}