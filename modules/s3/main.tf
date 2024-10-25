resource "aws_s3_bucket" "default" {
  bucket = var.bucket_name
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_public_access_block" "new_bucket_access" {
  bucket                  = aws_s3_bucket.default.id
  ignore_public_acls      = true
  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket_versioning" "new_bucket_versioning" {
  bucket = aws_s3_bucket.default.id
  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_logging" "default" {
  for_each = toset(length(var.logging) > 0 ? ["enabled"] : [])

  bucket                = aws_s3_bucket.default.bucket

  target_bucket = var.logging[0]["bucket_name"]
  target_prefix = var.logging[0]["prefix"]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket                = aws_s3_bucket.default.bucket

  rule {
    bucket_key_enabled = var.bucket_key_enabled

    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}
