resource "random_string" "bucket_suffix" {
  length           = 16
  numeric         = true
  special          = false
  upper = false
}

module buildspec_bucket {
  source = "../s3"
  bucket_name = "${var.project_name}-codebuild-spec-${random_string.bucket_suffix.result}"
  versioning_enabled = true
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "codepipeline_bucket_encryption" {
  count = var.kms_enabled ? 1 : 0
  bucket = module.buildspec_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

