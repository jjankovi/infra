variable "enviroment" {
  description = "Environment"
  type        = string
}

variable "project_name" {
  description = "Unique name for this project"
  type        = string
}

variable "terraform_provider_role" {
  type        = string
  description = "Role used by Terraform to provision resources"
}

variable "devops_state_bucket" {
  type        = string
  description = "S3 bucket where Terraform devops states will be stored"
}

variable "devops_state_lock_table" {
  type        = string
  description = "DynamoDB table which will be used by Terraform for devops state lock"
}