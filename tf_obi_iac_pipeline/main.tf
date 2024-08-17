module "pipeline" {
  source                     = "../modules/iac_pipeline"
  project_name               = "obi-iac"
  source_repo_connection_arn = "arn:aws:codeconnections:eu-central-1:058264153756:connection/2fa2ed0c-0d42-4730-aaac-8b8453acbf44"
  source_repo_id             = "jjankovi/obi-iac"
  source_repo_branch         = "main"
  kms_enabled                = false
  build_projects             = ["validate"]
  stage_input = [
    { name = "validate", category = "Build", input_artifacts = "SourceOutput", output_artifacts = "ValidateOutput" },
    #  { name = "plan", category = "Build", input_artifacts = "ValidateOutput", output_artifacts = "PlanOutput" }
    #  { name = "apply", category = "Build", input_artifacts = "PlanOutput", output_artifacts = "ApplyOutput" },
    #  { name = "destroy", category = "Build", input_artifacts = "ApplyOutput", output_artifacts = "DestroyOutput" }
  ]
  target_accounts = [
    { environment = "dev", account = "396608792866", workload_role = "arn:aws:iam::396608792866:role/WorkloadRole" }
  ]
}