
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_s3_object" "buildspec" {
  depends_on = [
    module.s3_codebuild_templates_bucket
  ]
  for_each = toset(var.build_projects)
  bucket = module.s3_codebuild_templates_bucket.bucket
  key    = "buildspec_${each.key}.yml"
}