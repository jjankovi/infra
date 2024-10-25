variable "bucket_name" {
  description = "Unique name for S3 bucket"
  type        = string
}

variable "force_destroy" {
  type        = bool
  default     = false
  nullable    = false
}

variable "versioning_enabled" {
  type        = bool
  default     = true
  description = "A state of bucket versioning"
  nullable    = false
}

variable "logging" {
  type = list(object({
    bucket_name = string
    prefix      = string
  }))
  default     = []
  description = "Bucket access logging configuration. Empty list for no logging, list of 1 to enable logging."
  nullable    = false
}

variable "bucket_key_enabled" {
  type        = bool
  default     = false
  description = <<-EOT
  Set this to true to use Amazon S3 Bucket Keys for SSE-KMS, which may or may not reduce the number of AWS KMS requests.
  For more information, see: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-key.html
  EOT
  nullable    = false
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "The server-side encryption algorithm to use. Valid values are `AES256` and `aws:kms`"
  nullable    = false
}

variable "kms_master_key_arn" {
  type        = string
  default     = ""
  description = <<-EOT
  The AWS KMS master key ARN used for the `SSE-KMS` encryption. This can only be used when you set
  the value of `sse_algorithm` as `aws:kms`. The default aws/s3 AWS KMS master key is used if this
  element is absent while the `sse_algorithm` is `aws:kms`
  EOT
  nullable    = false
}