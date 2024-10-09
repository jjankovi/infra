variable "state_bucket_name" {
  type        = string
  description = "S3 bucket where Terraform states will be stored"
}

variable "state_dynamodb_table_name" {
  type        = string
  description = "DynamoDB table which will be used by Terraform for state lock"
}

variable "state_access_iam_roles" {
  type        = list(string)
  description = "List of IAM roles which will be assumed by Terraform"
}