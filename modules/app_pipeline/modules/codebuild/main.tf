
resource "aws_codebuild_project" "terraform_codebuild_project" {

  count = length(var.build_projects)

  name         = "${var.project_name}-${var.build_projects[count.index]}"
  service_role = var.role_arn
  encryption_key = var.kms_enabled ? var.kms_key_arn : null
  tags = var.tags

  artifacts {
    type = var.build_project_source
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
    buildspec = data.aws_s3_object.buildspec[var.build_projects[count.index]].body
  }
}