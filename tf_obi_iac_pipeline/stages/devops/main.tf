module "pipeline" {
  source                     = "../../../modules/iac_pipeline"
  project_name               = "obi-iac"
  source_repo_connection_arn = "arn:aws:codeconnections:eu-central-1:058264153756:connection/2fa2ed0c-0d42-4730-aaac-8b8453acbf44"
  source_repo_id             = "jjankovi/obi-iac"
  source_repo_branch         = "main"
  kms_enabled                = false
  build_projects             = ["scan", "plan", "apply"]
  cicd_role_arn              = data.terraform_remote_state.devops_tier0.outputs.cicd_role_arn
  cicd_role_name             = data.terraform_remote_state.devops_tier0.outputs.cicd_role_name
  workload_role_arn          = data.terraform_remote_state.dev_tier0.outputs.cicd_role_arn
  stage_input = [
    { name = "plan", category = "Build", input_artifacts = "SourceOutput", output_artifacts = "PlanOutput" },
    { name = "approve", category = "Approval", input_artifacts = "", output_artifacts = "" },
    { name = "apply", category = "Build", input_artifacts = "PlanOutput", output_artifacts = "" }
  ]
  target_accounts = [
    {
      environment      = "dev",
      state_bucket     = "csob-dev-terraform-state",
      state_lock_table = "arn:aws:dynamodb:eu-central-1:058264153756:table/csob-dev-terraform-state-lock",
      workload_role    = data.terraform_remote_state.dev_tier0.outputs.cicd_role_arn
    }
  ]
}

data "terraform_remote_state" "devops_tier0" {
  backend = "s3"
  config = {
    bucket         = "csob-devops-terraform-state"
    dynamodb_table = "csob-devops-terraform-state-lock"
    key            = "tier0.init.terraform.tfstate"
    encrypt        = true
    region         = "eu-central-1"
  }
}

data "terraform_remote_state" "dev_tier0" {
  backend = "s3"
  config = {
    bucket         = "csob-dev-terraform-state"
    dynamodb_table = "csob-dev-terraform-state-lock"
    key            = "tier0.init.terraform.tfstate"
    encrypt        = true
    region         = "eu-central-1"
  }
}