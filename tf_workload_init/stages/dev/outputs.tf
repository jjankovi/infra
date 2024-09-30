output "cicd_role_arn" {
  value       = aws_iam_role.cicd_workload_role.arn
  description = "TODO"
}

output "cicd_role_name" {
  value       = aws_iam_role.cicd_workload_role.name
  description = "TODO"
}

output "app_deployer_role_arn" {
  value       = aws_iam_role.app_deployer_role.arn
  description = "TODO"
}

output "app_deployer_role_name" {
  value       = aws_iam_role.app_deployer_role.name
  description = "TODO"
}