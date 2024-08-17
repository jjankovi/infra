locals {
  dynamo_state_table_name = "csob-obi-terraform-state-lock"
}

module "state_bucket" {
  source      = "../modules/s3"
  bucket_name = "csob-obi-terraform-state"
}

resource "aws_dynamodb_table" "state_lock_table" {
  name     = local.dynamo_state_table_name
  hash_key = "LockID"

  billing_mode = "PAY_PER_REQUEST"

  server_side_encryption {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}