module "init_state" {
  source          = "../../modules/state_setup"
  aws_namespace   = var.aws_namespace
  aws_environment = var.aws_environment
  aws_component   = var.aws_component
  aws_attributes  = var.aws_attributes

  state_access_iam_roles = var.state_access_iam_roles
}