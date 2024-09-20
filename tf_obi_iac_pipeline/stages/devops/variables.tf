variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS region where the resources are provisioned"
}

variable "devops_role_arn" {
  type        = string
  description = "Role used by Terraform to provision resources"
}
