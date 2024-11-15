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

variable "region" {
  type        = string
  default     = "eu-central-1"
}

variable "terraform_provider_role" {
  type        = string
  description = "Role used by Terraform to provision resources"
}

variable "cicd_ecr_repo_name" {
  type        = string
  description = "CICD ECR repository name where Docker images will be stored"
}

variable "private_subnet_ids" {
  type        = list(string)
  default = []
}

variable "security_group_ids" {
  type        = list(string)
  default = []
}