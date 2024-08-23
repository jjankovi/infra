resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = var.state_bucket_name
}

resource "aws_s3_bucket_public_access_block" "bucket_access" {
  bucket                  = aws_s3_bucket.terraform_state_bucket.id
  ignore_public_acls      = true
  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_state_lock_table" {
  name     = var.state_dynamodb_table_name
  hash_key = "LockID"

  billing_mode = "PAY_PER_REQUEST"

  server_side_encryption {
    enabled = false
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}