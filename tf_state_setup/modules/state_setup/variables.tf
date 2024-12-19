variable "state_access_iam_roles" {
  type        = list(string)
  description = "List of IAM roles which will be assumed by Terraform"
}