
data "aws_s3_object" "buildspec" {
  for_each = toset(var.build_projects)

  bucket = var.s3_codebuild_templates_bucket_name
  key    = "buildspec_${each.key}.yml"
}