
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
}

variable "tags" {
  description = "Tags to be applied to the codebuild project"
  type        = map(any)
}

variable "build_projects" {
  description = "Tags to be attached to the CodePipeline"
  type = set(object({
    name  = string
    cache  = bool
  }))
}

variable "builder_compute_type" {
  description = "Information about the compute resources the build project will use"
  type        = string
}

variable "builder_image" {
  description = "Docker image to use for the build project"
  type        = string
}

variable "builder_type" {
  description = "Type of build environment to use for related builds"
  type        = string
}

variable "builder_image_pull_credentials_type" {
  description = "Type of credentials AWS CodeBuild uses to pull images in your build."
  type        = string
}

variable "build_project_source" {
  description = "Information about the build output artifact location"
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