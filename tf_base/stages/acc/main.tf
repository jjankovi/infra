module "pipeline_terraform_role" {
  source        = "../../modules/pipeline_terraform_role"
  project_name = var.project_name
  enviroment = var.enviroment
  assumable_by_pipeline_terraform_role = [data.terraform_remote_state.devops_base.outputs.pipeline_role_arn]
}

module "pipeline_deployer_role" {
  source        = "../../modules/pipeline_deployer_role"
  project_name = var.project_name
  enviroment = var.enviroment
  assumable_by_pipeline_deployer_role = [data.terraform_remote_state.devops_base.outputs.pipeline_role_arn]
}

data "terraform_remote_state" "devops_base" {
  backend = "s3"
  config = {
    bucket         = var.devops_state_bucket
    dynamodb_table = var.devops_state_bucket
    key            = "base.terraform.tfstate"
    encrypt        = true
    region         = var.terraform_provider_role
  }
}