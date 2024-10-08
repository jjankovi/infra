module "eks_cluster" {
  source        = "../../modules/eks"
  project_name  = "obi"
  enviroment    = "dev"
  k8s_namespace = "obi-ns"
}

module "app_parameters" {
  source       = "../../modules/parameters"
  project_name = "obi"
  enviroment   = "dev"
  app_parameters = [
    {
      name        = "TEST_URL"
      value       = "ou yeah"
      type        = "String"
      description = "Url of test API"
    },
    {
      name        = "ENVIRONMENT"
      value       = "dev"
      type        = "String"
      description = "Application environment"
    }
  ]
}

#module "rds" {
#  source            = "../../modules/rds"
#  project_name      = "obi"
#  enviroment        = "dev"
#  high_availability = false
#  admin_username    = "superuser"
#  admin_password    = "supersecretpassword"
#}