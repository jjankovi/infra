resource "random_string" "bucket_suffix" {
  length           = 16
  numeric         = true
  special          = false
  upper = false
}

module codepipeline_bucket {
  source = "../s3"
  bucket_name = "${lower(var.project_name)}-pipeline-artefacts-${random_string.bucket_suffix.result}"
  versioning_enabled = false
}

resource "aws_s3_bucket_ownership_controls" "codepipeline_bucket_ownership" {
  bucket = module.codepipeline_bucket.bucket
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_logging" "codepipeline_bucket_logging" {
  bucket        = module.codepipeline_bucket.bucket
  target_bucket = module.codepipeline_bucket.bucket
  target_prefix = "log/"
}