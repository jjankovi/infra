resource "aws_s3_bucket" "state_bucket" {
  bucket = var.state_bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket_encryption" {
  bucket = aws_s3_bucket.state_bucket.bucket
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_access" {
  bucket                  = aws_s3_bucket.state_bucket.id
  ignore_public_acls      = true
  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

data "aws_iam_policy_document" "state_bucket_access_roles" {
  statement {
    principals {
      type        = "AWS"
      identifiers = var.state_access_iam_roles
    }

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      aws_s3_bucket.state_bucket.arn,
      "${aws_s3_bucket.state_bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "terraform_roles_state_bucket_access" {
  bucket = aws_s3_bucket.state_bucket.id
  policy = data.aws_iam_policy_document.state_bucket_access_roles.json
}