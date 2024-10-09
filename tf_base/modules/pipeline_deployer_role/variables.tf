variable "enviroment" {
  description = "Environment"
  type        = string
}

variable "project_name" {
  description = "Unique name for this project"
  type        = string
}

variable "assumable_by_pipeline_deployer_role" {
  type        = list(string)
  description = "List of IAM roles that can assume pipeline deployer role"
}