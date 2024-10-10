variable "kms_root_access" {
  description = "If root user should have full access to KMS key"
  type        = bool
}

variable "kms_access_roles" {
  description = "Roles which have usage access to KMS key"
  type        = list(string)
}

variable "tags" {
  description = "Tags to be attached to the KMS Key"
  type        = map(any)
  default = {}
}