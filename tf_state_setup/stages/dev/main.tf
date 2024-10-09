module "init_state" {
  source                    = "../../modules/state_setup"
  state_bucket_name         = var.state_bucket
  state_dynamodb_table_name = var.state_lock_table
  state_access_iam_roles = var.state_access_iam_roles
}