resource "aws_codebuild_project" "terraform_codebuild_project" {
  for_each = { for project in var.codebuild_project_config : project.name => project }

  name         = "${var.project_name}-${each.value.name}"
  service_role = var.role_arn
  encryption_key = var.kms_enabled ? var.kms_key_arn : null
  tags = var.tags

  artifacts {
    type = var.build_project_source
  }

  dynamic "cache" {
    for_each = each.value.cache ? [1] : []
    content {
      type = "S3"
      location = var.cache_bucket
    }
  }

  environment {
    compute_type                = var.builder_compute_type
    image                       = var.builder_image
    type                        = var.builder_type
    privileged_mode             = true
    image_pull_credentials_type = var.builder_image_pull_credentials_type
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  source {
    type      = var.build_project_source
    buildspec = data.aws_s3_object.buildspec[each.value.name].body
  }
}