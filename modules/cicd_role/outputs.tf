output "arn" {
  value       = aws_iam_role.cicd_role.arn
  description = "ARN of the IAM role used by CICD Pipeline."
}

output "name" {
  value       = aws_iam_role.cicd_role.name
  description = "The name of the IAM role used by CICD Pipeline."
}