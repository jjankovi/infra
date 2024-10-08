#Module for creating a new S3 bucket for storing pipeline artifacts
module "codebuild_artifacts_bucket" {
  source                = "./modules/s3_codebuild_artefacts"
  project_name          = var.project_name
  kms_key_arn           = module.codepipeline_kms.arn
  kms_enabled = var.kms_enabled
  codepipeline_role_arn = var.cicd_role.arn
  tags = {
    Project_Name = var.project_name
    Environment  = var.environment
    Account_ID   = local.account_id
    Region       = local.region
  }
}

module "codebuild_cache_bucket" {
  source                = "./modules/s3_codebuild_cache"
  project_name          = var.project_name
  kms_key_arn           = module.codepipeline_kms.arn
  kms_enabled = var.kms_enabled
  codepipeline_role_arn = var.cicd_role.arn
  tags = {
    Project_Name = var.project_name
    Environment  = var.environment
    Account_ID   = local.account_id
    Region       = local.region
  }
}

#Module for creating a new S3 bucket for storing codebuild buildspec
module "codebuild_templates_bucket" {
  source         = "./modules/s3_buildspec_templates"
  build_projects = tolist([for project in var.build_projects : project.name])
  project_name = var.project_name
  kms_key_arn    = module.codepipeline_kms.arn
  kms_enabled = var.kms_enabled
}

# Module for Infrastructure CodeBuild projects
module "codebuild_terraform" {
  source = "./modules/codebuild"
  depends_on = [
    module.codebuild_templates_bucket,
    module.codebuild_cache_bucket
  ]
  project_name                        = var.project_name
  role_arn                            = var.cicd_role.arn
  templates_bucket                    = module.codebuild_templates_bucket.bucket
  cache_bucket                        = module.codebuild_cache_bucket.bucket
  build_projects                      = var.build_projects
  build_project_source                = var.build_project_source
  builder_compute_type                = var.builder_compute_type
  builder_image                       = var.builder_image
  builder_image_pull_credentials_type = var.builder_image_pull_credentials_type
  builder_type                        = var.builder_type
  kms_key_arn                         = module.codepipeline_kms.arn
  kms_enabled = var.kms_enabled
  tags = {
    Project_Name = var.project_name
    Environment  = var.environment
    Account_ID   = local.account_id
    Region       = local.region
  }
}

module "codepipeline_kms" {
  source                = "./modules/kms"
  codepipeline_role_arn = var.cicd_role.arn
  tags = {
    Project_Name = var.project_name
    Environment  = var.environment
    Account_ID   = local.account_id
    Region       = local.region
  }
}

module "codepipeline_iam_role" {
  source                     = "./modules/iam_role"
  project_name               = var.project_name
  cicd_role_name = var.cicd_role.name
  workload_roles = tolist([for role in var.target_accounts : role.workload_role])
  codestar_connection_arn    = var.source_repo.connection_arn
  kms_key_arn                = module.codepipeline_kms.arn
  s3_bucket_arn              = module.codebuild_artifacts_bucket.arn
  tags = {
    Project_Name = var.project_name
    Environment  = var.environment
    Account_ID   = local.account_id
    Region       = local.region
  }
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
