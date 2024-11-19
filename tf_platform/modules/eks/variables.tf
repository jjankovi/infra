variable "aws_namespace" {
  type        = string
  default     = "csob"
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "aws_environment" {
  type        = string
  default     = ""
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "aws_component" {
  type        = string
  default     = ""
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "aws_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "aws_attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "private_subnet_ids" {
  description = "List of private subnet ids"
  type        = list(string)
}

variable "eks_admin_roles" {
  description = "List of IAM roles to have cluster admin rights in EKS cluster"
  type        = list(string)
}

variable "k8s_app_namespace" {
  description = "Kubernetes application namespace"
  type        = string
}