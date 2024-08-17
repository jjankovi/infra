variable "bucket_name" {
  description = "Unique name for S3 bucket"
  type        = string
}

variable "bucket_versioning" {
  description = "Flag is bucket versioning is enabled"
  type        = bool
  default = false
}