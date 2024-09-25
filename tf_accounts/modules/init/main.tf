resource "aws_s3_bucket" "state_bucket" {
  bucket = var.state_bucket_name
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

resource "aws_s3_bucket_policy" "bucket_access_from_workload_account" {
  bucket = aws_s3_bucket.state_bucket.id
  policy = data.aws_iam_policy_document.bucket_access_from_workload_account.json
}

data "aws_iam_policy_document" "bucket_access_from_workload_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = var.workload_roles
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

resource "aws_dynamodb_table" "state_lock_table" {
  name     = var.state_dynamodb_table_name
  hash_key = "LockID"

  billing_mode = "PAY_PER_REQUEST"

  server_side_encryption {
    enabled = false
  }

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_dynamodb_resource_policy" "lock_table_access_from_workload_account" {
  resource_arn = aws_dynamodb_table.state_lock_table.arn
  policy       = data.aws_iam_policy_document.lock_table_access_from_workload_account.json
}

data "aws_iam_policy_document" "lock_table_access_from_workload_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = var.workload_roles
    }

    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:DeleteItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateItem"
    ]

    resources = [
      "${aws_dynamodb_table.state_lock_table.arn}"
    ]
  }
}