locals {
  account_id          = data.aws_caller_identity.current.account_id
  region              = data.aws_region.current.name
  codebuild_spec_path = "../../specs"

  source_repo = {
    id             = "jjankovi/obi",
    connection_arn = "arn:aws:codeconnections:eu-central-1:058264153756:connection/2fa2ed0c-0d42-4730-aaac-8b8453acbf44",
    branch         = "main"
  }

  cicd_role = {
    name = data.terraform_remote_state.devops_tier0.outputs.cicd_role_name,
    arn  = data.terraform_remote_state.devops_tier0.outputs.cicd_role_arn
  }

  codebuild_project_config = [
    { name = "scan", cache = false },
    { name = "build", cache = false },
    { name = "diff", cache = false },
    { name = "deploy", cache = false }
  ]

  codepipeline_stage_config = [
    { name = "diff", category = "Build", input_artifacts = "SourceOutput", output_artifacts = "DiffOutput" },
    { name = "approve", category = "Approval", input_artifacts = "", output_artifacts = "" },
    { name = "deploy", category = "Build", input_artifacts = "SourceOutput", output_artifacts = "" }
  ]

  target_accounts = [
    {
      environment   = "dev",
      account       = "396608792866",
      deployer_role = data.terraform_remote_state.dev_tier0.outputs.app_deployer_role_arn
    }
  ]
}

module "ecr_repo" {
  source            = "../../../modules/ecr"
  project_name      = var.project_name
  full_access_roles = [local.cicd_role.name]
  read_access_roles = toset([for target_account in local.target_accounts : target_account.deployer_role])
}

module "codebuild_artifacts_bucket" {
  source                = "../../../modules/codebuild_artefacts"
  project_name          = var.project_name
  kms_key_arn           = module.codepipeline_kms.arn
  kms_enabled           = var.kms_enabled
  codepipeline_role_arn = local.cicd_role.arn
}

module "codebuild_spec_bucket" {
  source       = "../../../modules/codebuild_spec"
  project_name = var.project_name
  kms_key_arn  = module.codepipeline_kms.arn
  kms_enabled  = var.kms_enabled
}

resource "aws_s3_object" "codebuild_specs" {
  bucket = module.codebuild_spec_bucket.bucket

  for_each = tomap({ for project in local.codebuild_project_config : project.name => project })

  key          = "buildspec_${each.key}.yml"
  content_type = "text/plain"
  source       = "${local.codebuild_spec_path}/buildspec_${each.key}.yml"
  etag         = filemd5("${local.codebuild_spec_path}/buildspec_${each.key}.yml")
}

module "codebuild_terraform" {
  source = "../../../modules/codebuild_project"
  depends_on = [
    module.codebuild_spec_bucket,
    data.aws_s3_object.codebuild_specs_data
  ]
  project_name             = var.project_name
  role_arn                 = local.cicd_role.arn
  templates_bucket         = module.codebuild_spec_bucket.bucket
  codebuild_project_config = local.codebuild_project_config
  kms_enabled              = var.kms_enabled
  kms_key_arn              = module.codepipeline_kms.arn
}

module "codepipeline_kms" {
  source           = "../../../modules/kms"
  kms_root_access  = true
  kms_access_roles = [local.cicd_role.arn]
}

module "codepipeline_iam_role" {
  source                  = "../../modules/iam_role"
  project_name            = var.project_name
  cicd_role_name          = local.cicd_role.name
  deployer_roles          = tolist([for role in local.target_accounts : role.deployer_role])
  codestar_connection_arn = local.source_repo.connection_arn
  kms_key_arn             = module.codepipeline_kms.arn
  s3_bucket_arn           = module.codebuild_artifacts_bucket.arn
}

# Module for CodePipeline
module "codepipeline_terraform" {
  depends_on = [
    module.codebuild_terraform,
    module.codebuild_artifacts_bucket,
  ]
  source = "../../modules/codepipeline"

  project_name            = var.project_name
  codestar_connection_arn = local.source_repo.connection_arn
  source_repo_id          = local.source_repo.id
  source_repo_branch      = local.source_repo.branch
  ecr_repo                = module.ecr_repo.ecr_repo_url
  s3_bucket_name          = module.codebuild_artifacts_bucket.bucket
  codepipeline_role_arn   = local.cicd_role.arn
  stages                  = local.codepipeline_stage_config
  target_accounts         = local.target_accounts
  kms_key_arn             = module.codepipeline_kms.arn
  kms_enabled             = var.kms_enabled
}