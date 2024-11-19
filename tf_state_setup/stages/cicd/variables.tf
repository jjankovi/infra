variable "aws_namespace" {
  type    = string
  default = null
}

variable "aws_environment" {
  type    = string
  default = null
}

variable "aws_component" {
  type    = string
  default = null
}

variable "aws_attributes" {
  type    = list(string)
  default = []
}

variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS region where the resources are provisioned"
}

variable "state_access_iam_roles" {
  type        = list(string)
  description = "List of IAM roles which will have access to Terraform state objects"
}