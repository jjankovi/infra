variable "environment" {
  description = "Environment"
  type        = string
}

variable "project_name" {
  description = "Unique name for this project"
  type        = string
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