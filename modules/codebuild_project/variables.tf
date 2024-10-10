variable "project_name" {
  description = "Unique name for this project"
  type        = string
}

variable "role_arn" {
  description = "Codepipeline IAM role arn. "
  type        = string
  default     = ""
}

variable "templates_bucket" {
  description = "Name of the S3 bucket used to store the codebuild templates"
  type        = string
}

variable "cache_bucket" {
  description = "Name of the S3 bucket used to store cache"
  type        = string
  default = ""
}

variable "tags" {
  description = "Tags to be applied to the codebuild project"
  type        = map(any)
  default = {}
}

variable "build_projects" {
  description = "TODO popis"
  type = set(object({
    name  = string
    cache  = bool
  }))
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

variable "builder_compute_type" {
  description = "Relative path to the Apply and Destroy build spec file"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "builder_image" {
  description = "Docker Image to be used by codebuild"
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
}

variable "builder_type" {
  description = "Type of codebuild run environment"
  type        = string
  default     = "LINUX_CONTAINER"
}

variable "builder_image_pull_credentials_type" {
  description = "Image pull credentials type used by codebuild project"
  type        = string
  default     = "CODEBUILD"
}

variable "build_project_source" {
  description = "aws/codebuild/standard:4.0"
  type        = string
  default     = "CODEPIPELINE"
}