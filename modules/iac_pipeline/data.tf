
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_s3_object" "buildspec" {
  for_each = toset([for project in var.build_projects : project.name])
  bucket = module.codebuild_templates_bucket.bucket
  key    = "buildspec_${each.value}.yml"
}