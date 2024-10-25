variable "deletion_window_in_days" {
  type        = number
  default     = 10
  description = "Duration in days after which the key is deleted after destruction of the resource"
}

variable "enable_key_rotation" {
  type        = bool
  default     = false
  description = "Specifies whether key rotation is enabled"
}

variable "alias" {
  type        = string
  default     = ""
  description = "The display name of the alias. The name must start with the word `alias` followed by a forward slash. If not specified, the alias name will be auto-generated."
}

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