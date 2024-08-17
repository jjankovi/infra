
variable "project_name" {
  description = "Unique name for this project"
  type        = string
}

variable "source_repo_connection_arn" {
  description = "ARN of CodeStarConnection used as source repo for"
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

variable "environment" {
  description = "Environment in which the script is run. Eg: devops, dev, prod, etc"
  type        = string
  default     = "devops"
}

variable "build_projects" {
  description = "Tags to be attached to the CodePipeline"
  type        = list(string)
}

variable "target_accounts" {
  description = "Accounts where CodePipeline will install resources to"
  type        = list(map(any))
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
