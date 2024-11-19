locals {
  default_aws_attributes = [

  ]
  default_aws_tags = {
    "Terraform"            = "true",
    "Terraform-repository" = "tf_platform"
  }
}

module "label" {
  source      = "../../../modules/label"
  namespace   = var.aws_namespace
  stage = var.aws_environment
  name        = var.aws_component
  attributes  = concat(var.aws_attributes, local.default_aws_attributes)
  tags        = merge(var.aws_tags, local.default_aws_tags)
}