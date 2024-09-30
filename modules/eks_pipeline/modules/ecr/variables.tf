variable "project_name" {
  description = "Unique name for this project"
  type        = string
}

variable "cicd_role_name" {
  description = "Name of the cicd IAM role"
  type        = string
}

variable "workload_accounts" {
  description = "Workload accounts ids which will fetch docker images from ECR repo"
  type        = list(string)
}