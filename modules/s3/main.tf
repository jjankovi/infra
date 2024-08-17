resource "aws_s3_bucket" "new_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "new_bucket_access" {
  bucket                  = aws_s3_bucket.new_bucket.id
  ignore_public_acls      = true
  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket_versioning" "new_bucket_versioning" {
  bucket = aws_s3_bucket.new_bucket.id
  versioning_configuration {
    status = var.bucket_versioning ? "Enabled" : "Disabled"
  }
}