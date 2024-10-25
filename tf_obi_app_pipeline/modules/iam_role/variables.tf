
variable "project_name" {
  description = "Unique name for this project"
  type        = string
}

variable "cicd_role_name" {
  description = "Name of CICD IAM role to be used by the project"
  type        = string
}

variable "deployer_roles" {
  description = "IAM roles which are used to deploy an application"
  type        = list(string)
}

variable "tags" {
  description = "Tags to be attached to the IAM Role"
  type        = map(any)
  default = {}
}

variable "codestar_connection_arn" {
  description = "The ARN of the repo codestar connection"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of KMS key for encryption"
  type        = string
}

variable "s3_bucket_arn" {
  description = "The ARN of the S3 Bucket"
  type        = string
}