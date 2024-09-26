module "pipeline" {
  source                     = "../../../modules/eks_pipeline"
  project_name               = "obi"
  source_repo_connection_arn = "arn:aws:codeconnections:eu-central-1:058264153756:connection/2fa2ed0c-0d42-4730-aaac-8b8453acbf44"
  source_repo_id             = "jjankovi/obi"
  source_repo_branch         = "main"
  kms_enabled                = false
  build_projects             = ["scan", "build", "diff", "apply"]
  cicd_role_arn              = data.terraform_remote_state.devops_tier0.outputs.cicd_role_arn
  cicd_role_name             = data.terraform_remote_state.devops_tier0.outputs.cicd_role_name
  workload_role_arn          = data.terraform_remote_state.dev_tier0.outputs.cicd_role_arn
  stage_input = [
        { name = "diff", category = "Build", input_artifacts = "SourceOutput", output_artifacts = "DiffOutput" }
    #    { name = "approve", category = "Approval", input_artifacts = "", output_artifacts = "" },
    #    { name = "apply", category = "Build", input_artifacts = "DiffOutput", output_artifacts = "" }
  ]
  target_accounts = [
    {
      environment      = "dev",
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