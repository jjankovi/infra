variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS region where the resources are provisioned"
}

variable "state_bucket" {
  type        = string
  description = "TODO"
}

variable "state_lock_table" {
  type        = string
  description = "TODO"
}

variable "devops_role_arn" {
  type        = string
  description = "TODO Role used by Terraform to provision resources"
}

variable "workload_roles" {
  type        = list(string)
  description = "TODO"
}