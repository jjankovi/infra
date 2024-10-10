variable "project_name" {
  description = "Unique name for this project"
  type        = string
}

variable "environment" {
  description = "Environment in which the script is run. Eg: devops, dev, prod, etc"
  type        = string
}

variable "kms_enabled" {
  description = "Flag if kms encryption is enabled in all resources"
  type        = bool
  default     = true
}

variable "source_repo" {
  description = "Git repo used as source for CodePipeline"
  type = object({
    id  = string
    connection_arn  = string
    branch = string
  })
}

variable "cicd_role" {
  description = "CICD IAM role to be used by the project"
  type = object({
    name  = string
    arn  = string
  })
}

variable "stage_input" {
  description = "Tags to be attached to the CodePipeline"
  type        = list(map(any))
}

variable "build_projects" {
  description = "Tags to be attached to the CodePipeline"
  type = set(object({
    name  = string
    cache  = bool
  }))
}

variable "target_accounts" {
  description = "Accounts where CodePipeline will install resources to"
  type = list(object({
    environment  = string
    state_bucket = string
    state_lock_table = string
    workload_role = string
  }))
}
