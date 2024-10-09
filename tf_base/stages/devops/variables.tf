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