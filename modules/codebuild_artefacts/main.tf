#Artifact Bucket
resource "random_string" "bucket_suffix" {
  length           = 16
  numeric         = true
  special          = false
  upper = false
}

module codepipeline_bucket {
  source = "../s3"
  bucket_name = "${lower(var.project_name)}-artefacts-${random_string.bucket_suffix.result}"
}

resource "aws_s3_bucket_policy" "bucket_policy_codepipeline_bucket" {
  bucket = module.codepipeline_bucket.bucket
  policy = data.aws_iam_policy_document.bucket_policy_doc_codepipeline_bucket.json
}

data "aws_iam_policy_document" "bucket_policy_doc_codepipeline_bucket" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.codepipeline_role_arn]
    }

    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:ReplicateObject",
      "s3:PutObject",
      "s3:RestoreObject",
      "s3:PutObjectVersionTagging",
      "s3:PutObjectTagging",
      "s3:PutObjectAcl"
    ]

    resources = [
      module.codepipeline_bucket.bucket_arn,
      "${module.codepipeline_bucket.bucket_arn}/*",
    ]
  }
}

resource "aws_s3_bucket_ownership_controls" "codepipeline_bucket_ownership" {
  bucket = module.codepipeline_bucket.bucket
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_logging" "codepipeline_bucket_logging" {
  bucket        = module.codepipeline_bucket.bucket
  target_bucket = module.codepipeline_bucket.bucket
  target_prefix = "log/"
}