variable "project_name" {
  description = "Unique name for this project"
  type        = string
}

variable "full_access_roles" {
  description = "Name of the roles which have full access to ECR"
  type        = set(string)
}

variable "read_access_roles" {
  description = "Name of the roles which have read access to ECR"
  type        = set(string)
}