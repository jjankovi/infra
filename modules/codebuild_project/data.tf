data "aws_s3_object" "buildspec" {
  for_each = toset([for project in var.codebuild_project_config : project.name])

  bucket = var.templates_bucket
  key    = "buildspec_${each.value}.yml"
}