variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS region where the resources are provisioned"
}

variable "state_bucket" {
  type        = string
  description = "S3 bucket where Terraform states will be stored"
}

variable "state_lock_table" {
  type        = string
  description = "DynamoDB table which will be used by Terraform for state lock"
}

variable "terraform_provider_role" {
  type        = string
  description = "Role used by Terraform to provision resources"
}

variable "state_access_iam_roles" {
  type        = list(string)
  description = "List of IAM roles which will be assumed by Terraform"
}