output "cicd_role_arn" {
  value       = aws_iam_role.codepipeline_role.arn
  description = "TODO"
}

output "cicd_role_name" {
  value       = aws_iam_role.codepipeline_role.name
  description = "TODO"
}