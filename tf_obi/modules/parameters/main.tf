resource "aws_ssm_parameter" "app_parameters" {
  for_each    = { for param in var.app_parameters : param.name => param }

  name        = "/app/${var.project_name}/${each.value.name}"
  value       = each.value.value
  type        = each.value.type
  description = each.value.description

  tags = {
    Application = var.project_name
    Environment = var.enviroment
  }
}