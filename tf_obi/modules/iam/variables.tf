variable "project_name" {
  description = "Unique name for this project"
  type        = string
}

variable "oidc_provider_id" {
  description = "OIDC provider"
  type        = string
}

variable "k8s_app_namespace" {
  description = "Kubernetes application namespace"
  type        = string
}

variable "k8s_app_sa_name" {
  description = "Kubernetes ServiceAccount name used by application"
  type        = string
}