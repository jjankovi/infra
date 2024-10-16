variable "project_name" {
  description = "Unique name for this project"
  type        = string
}

variable "full_access_roles" {
  description = "ARN of the roles which have full access to ECR"
  type        = set(string)
  default = []
}

variable "read_access_roles" {
  description = "ARN of the roles which have read access to ECR"
  type        = set(string)
  default = []
}