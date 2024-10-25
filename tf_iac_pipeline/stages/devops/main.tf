data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id          = data.aws_caller_identity.current.account_id
  region              = data.aws_region.current.name
  codebuild_spec_path = "../../specs"
}

data "aws_s3_object" "codebuild_specs_data" {
  depends_on = [
    aws_s3_object.codebuild_specs
  ]
  for_each = toset([for project in var.codebuild_projects_config : project.name])
  bucket   = module.codebuild_spec_bucket.bucket
  key      = "buildspec_${each.value}.yml"
}

module "cicd_role" {
  source                  = "../../../modules/cicd_role"
  project_name            = var.project_name
  cicd_crossaccount_roles = tolist([for role in var.target_accounts : role.workload_role])
  codestar_connection_arn = var.source_repo.connection_arn
  kms_key_arn             = module.cicd_kms.key_arn
  artifacts_bucket_arn    = module.codebuild_artifacts_bucket.arn
}

module "cicd_kms" {
  source           = "../../../modules/kms"
  kms_root_access  = true
}

module "codebuild_artifacts_bucket" {
  source                = "../../../modules/codebuild_artefacts"
  project_name          = var.project_name
  kms_key_arn           = module.cicd_kms.key_arn
  kms_enabled           = var.kms_enabled
}

module "codebuild_spec_bucket" {
  source       = "../../../modules/codebuild_spec"
  project_name = var.project_name
  kms_key_arn  = module.cicd_kms.key_arn
  kms_enabled  = var.kms_enabled
}

resource "aws_s3_object" "codebuild_specs" {
  bucket = module.codebuild_spec_bucket.bucket

  for_each = tomap({ for project in var.codebuild_projects_config : project.name => project })

  key          = "buildspec_${each.key}.yml"
  content_type = "text/plain"
  source       = "${local.codebuild_spec_path}/buildspec_${each.key}.yml"
  etag         = filemd5("${local.codebuild_spec_path}/buildspec_${each.key}.yml")
}

module "codebuild_projects" {
  source = "../../../modules/codebuild_project"
  depends_on = [
    module.codebuild_spec_bucket
  ]
  project_name             = var.project_name
  role_arn                 = module.cicd_role.arn
  templates_bucket         = module.codebuild_spec_bucket.bucket
  codebuild_projects_config = var.codebuild_projects_config
  kms_enabled              = var.kms_enabled
  kms_key_arn              = module.cicd_kms.key_arn
}

module "codepipeline_terraform" {
  source = "../../modules/codepipeline"
  depends_on = [
    module.codebuild_projects,
    module.codebuild_artifacts_bucket,
  ]
  project_name            = var.project_name
  codestar_connection_arn = var.source_repo.connection_arn
  source_repo_id          = var.source_repo.id
  source_repo_branch      = var.source_repo.branch
  artifacts_bucket_arn    = module.codebuild_artifacts_bucket.bucket
  cicd_role_arn           = module.cicd_role.arn
  codepipeline_stages_config = var.codepipeline_stages_config
  target_accounts         = var.target_accounts
  kms_key_arn             = module.cicd_kms.key_arn
  kms_enabled             = var.kms_enabled
}