locals {
  codebuild_spec_path = "../../../modules/iac_pipeline/modules/codebuild_specs"
}

module "codebuild_artifacts_bucket" {
  source                = "../codebuild_artefacts"
  project_name          = var.project_name
  kms_key_arn           = module.codepipeline_kms.arn
  kms_enabled = var.kms_enabled
  codepipeline_role_arn = var.cicd_role.arn
}

module "codebuild_cache_bucket" {
  source                = "../codebuild_cache"
  project_name          = var.project_name
  kms_key_arn           = module.codepipeline_kms.arn
  kms_enabled = var.kms_enabled
  codepipeline_role_arn = var.cicd_role.arn
}

module "codebuild_spec_bucket" {
  source         = "../codebuild_spec"
  project_name = var.project_name
  kms_key_arn    = module.codepipeline_kms.arn
  kms_enabled = var.kms_enabled
}

resource "aws_s3_object" "codebuild_specs" {
  bucket   = module.codebuild_spec_bucket.bucket

  for_each = tomap({ for project in var.build_projects : project.name => project })

  key          = "buildspec_${each.key}.yml"
  content_type = "text/plain"
  source       = "${local.codebuild_spec_path}/buildspec_${each.key}.yml"
  etag         = filemd5("${local.codebuild_spec_path}/buildspec_${each.key}.yml")
}


module "codebuild_terraform" {
  source = "../codebuild_project"
  depends_on = [
    module.codebuild_spec_bucket,
    module.codebuild_cache_bucket
  ]
  project_name                        = var.project_name
  role_arn                            = var.cicd_role.arn
  templates_bucket                    = module.codebuild_spec_bucket.bucket
  cache_bucket                        = module.codebuild_cache_bucket.bucket
  build_projects                      = var.build_projects
  kms_enabled = var.kms_enabled
  kms_key_arn                         = module.codepipeline_kms.arn
}

module "codepipeline_kms" {
  source                = "../kms"
  kms_root_access = true
  kms_access_roles = [var.cicd_role.arn]
}

module "codepipeline_iam_role" {
  source                     = "./modules/iam_role"
  project_name               = var.project_name
  cicd_role_name = var.cicd_role.name
  workload_roles = tolist([for role in var.target_accounts : role.workload_role])
  codestar_connection_arn    = var.source_repo.connection_arn
  kms_key_arn                = module.codepipeline_kms.arn
  s3_bucket_arn              = module.codebuild_artifacts_bucket.arn
}

# Module for CodePipeline
module "codepipeline_terraform" {
  source = "./modules/codepipeline"
  depends_on = [
    module.codebuild_terraform,
    module.codebuild_artifacts_bucket,
  ]
  project_name            = var.project_name
  codestar_connection_arn = var.source_repo.connection_arn
  source_repo_id          = var.source_repo.id
  source_repo_branch      = var.source_repo.branch
  s3_bucket_name          = module.codebuild_artifacts_bucket.bucket
  codepipeline_role_arn   = var.cicd_role.arn
  stages                  = var.stage_input
  target_accounts         = var.target_accounts
  kms_key_arn             = module.codepipeline_kms.arn
  kms_enabled = var.kms_enabled
  tags = {
    Project_Name = var.project_name
    Environment  = var.environment
    Account_ID   = local.account_id
    Region       = local.region
  }
}
