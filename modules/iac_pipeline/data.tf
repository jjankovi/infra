
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_s3_object" "codebuild_specs_data" {
  depends_on = [
    aws_s3_object.codebuild_specs
  ]
  for_each = toset([for project in var.build_projects : project.name])
  bucket = module.codebuild_spec_bucket.bucket
  key    = "buildspec_${each.value}.yml"
}