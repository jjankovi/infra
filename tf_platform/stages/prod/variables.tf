variable "environment" {
  description = "Environment"
  type        = string
  default = "prod"
}

variable "project_name" {
  description = "Unique name for this project"
  type        = string
}

variable "terraform_provider_role" {
  type        = string
  description = "Role used by Terraform to provision resources"
}

variable "region" {
  type        = string
  default     = "eu-central-1"
}

variable "k8s_app_namespace" {
  type        = string
}

variable "eks_admin_roles" {
  type        = list(string)
}

variable "private_subnet_ids" {
  type        = list(string)
}
