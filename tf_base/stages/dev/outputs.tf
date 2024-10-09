output "pipeline_terraform_role_arn" {
  value       = module.pipeline_terraform_role.pipeline_terraform_role_arn
}

output "pipeline_terraform_role_name" {
  value       = module.pipeline_terraform_role.pipeline_terraform_role_name
}

output "pipeline_deployer_role_arn" {
  value       = module.pipeline_deployer_role.pipeline_deployer_role_arn
}

output "pipeline_deployer_role_name" {
  value       = module.pipeline_deployer_role.pipeline_deployer_role_name
}