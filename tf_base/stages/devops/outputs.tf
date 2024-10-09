output "pipeline_role_arn" {
  value       = module.pipeline_role.pipeline_role_arn
  description = "ARN of the IAM role used by CICD Pipeline."
}

output "pipeline_role_name" {
  value       = module.pipeline_role.pipeline_role_name
  description = "The name of the IAM role used by CICD Pipeline."
}