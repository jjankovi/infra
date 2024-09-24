
resource "random_string" "bucket_suffix" {
  length           = 16
  numeric         = true
  special          = false
  upper = false
}

module buildspec_bucket {
  source = "../../../s3"
  bucket_name = "codebuild-templates-${random_string.bucket_suffix.result}"
  bucket_versioning = true
}

resource "aws_s3_bucket_public_access_block" "codebuild_templates_bucket_access" {
  bucket                  = module.buildspec_bucket.bucket
  ignore_public_acls      = true
  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket_versioning" "codebuild_templates_bucket_versioning" {
  bucket = module.buildspec_bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
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

resource "aws_s3_object" "buildspec_validate" {
  bucket   = module.buildspec_bucket.bucket
  for_each = toset(var.build_projects)

  key          = "buildspec_${each.key}.yml"
  content_type = "text/plain"

  source       = "../../../modules/eks_pipeline/codebuild_buildspecs/buildspec_${each.key}.yml"
  etag         = filemd5("../../../modules/eks_pipeline/codebuild_buildspecs/buildspec_${each.key}.yml")
}