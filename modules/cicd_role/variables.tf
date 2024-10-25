variable "project_name" {
  description = "Unique name for this project"
  type        = string
}

variable "cicd_crossaccount_roles" {
  description = "IAM roles which are used to deploy AWS resources cross accounts"
  type        = list(string)
}

variable "kms_key_arn" {
  description = "ARN of KMS key for encryption"
  type        = string
}

variable "codestar_connection_arn" {
  description = "The ARN of the repo codestar connection"
  type        = string
}

variable "artifacts_bucket_arn" {
  description = "The ARN of the S3 pipeline artifacts Bucket"
  type        = string
}