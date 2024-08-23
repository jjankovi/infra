module "init_state" {
  source                    = "../../modules/init"
  state_bucket_name         = var.state_bucket
  state_dynamodb_table_name = var.state_lock_table
}