module "pipeline" {
  source         = "../../../modules/app_pipeline"
  project_name   = "obi"
  environment    = "devops"
  kms_enabled    = false
  build_projects = ["scan", "build", "diff", "deploy"]
  source_repo = {
    id             = "jjankovi/obi",
    connection_arn = "arn:aws:codeconnections:eu-central-1:058264153756:connection/2fa2ed0c-0d42-4730-aaac-8b8453acbf44",
    branch         = "main"
  }
  cicd_role = {
    name = data.terraform_remote_state.devops_tier0.outputs.cicd_role_name,
    arn  = data.terraform_remote_state.devops_tier0.outputs.cicd_role_arn
  }
  stage_input = [
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