module "init_state" {
  source     = "../../modules/state_setup"
  namespace = var.namespace
  stage = var.stage
  name = var.name

  state_access_iam_roles = var.state_access_iam_roles
}