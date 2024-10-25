variable "project_name" {
  description = "Unique name for this project"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "app_parameters" {
  type = list(object({
    name  = string
    value = string
    type  = string
    description = optional(string)
  }))
}