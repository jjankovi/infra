module "pipeline" {
  source         = "../../../modules/iac_pipeline"
  project_name   = "obi-iac"
  environment    = "devops"
  kms_enabled    = false
  build_projects = ["scan", "plan", "apply"]
  source_repo = {
    id             = "jjankovi/obi-iac",
    connection_arn = "arn:aws:codeconnections:eu-central-1:058264153756:connection/2fa2ed0c-0d42-4730-aaac-8b8453acbf44",
    branch         = "main"
  }
  cicd_role = {
    name = data.terraform_remote_state.devops_tier0.outputs.cicd_role_name,
    arn  = data.terraform_remote_state.devops_tier0.outputs.cicd_role_arn
  }
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