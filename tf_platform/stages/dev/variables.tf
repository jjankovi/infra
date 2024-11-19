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
  type    = string
  default = "eu-central-1"
}

variable "k8s_app_namespace" {
  type = string
}

variable "eks_admin_roles" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}
