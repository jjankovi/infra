
variable "project_name" {
  description = "Unique name for this project"
  type        = string
}

variable "codestar_connection_arn" {
  description = "The ARN of the repo codestar connection"
  type        = string
}

variable "source_repo_id" {
  description = "Source repo id"
  type        = string
}

variable "source_repo_branch" {
  description = "Default branch in the Source repo for which CodePipeline needs to be configured"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name to be used for storing the artifacts"
  type        = string
}

variable "codepipeline_role_arn" {
  description = "ARN of the codepipeline IAM role"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of KMS key for encryption"
  type        = string
}

variable "kms_enabled" {
  description = "Flag if kms encryption is enabled in all resources"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to be attached to the CodePipeline"
  type        = map(any)
}

variable "stages" {
  description = "List of Map containing information about the stages of the CodePipeline"
  type        = list(map(any))
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
