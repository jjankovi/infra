variable "project_name" {
  description = "Unique name for this project"
  type        = string
  default     = "obi-iac"
}

variable "environment" {
  description = "Environment in which the script is run. Eg: devops, dev, prod, etc"
  type        = string
  default     = "devops"
}

variable "kms_enabled" {
  description = "Flag if kms encryption is enabled in all resources"
  type        = bool
  default     = false
}

variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS region where the resources are provisioned"
}

variable "devops_role_arn" {
  type        = string
  description = "Role used by Terraform to provision resources"
}
