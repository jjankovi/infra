module "pipeline_role" {
  source        = "../../modules/pipeline_role"
  project_name = var.project_name
  enviroment = var.enviroment
}