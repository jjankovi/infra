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

#resource "aws_secretsmanager_secret" "db_password_secret" {
#  name = "obi_db_pass_01"
#}
#
#resource "aws_secretsmanager_secret_version" "db_password_secret_version" {
#  secret_id     = aws_secretsmanager_secret.db_password_secret.id
#  secret_string = "vqUVyzeeBoIbrMHbkrSpYafGsGodLYEqmaXDovSAmTZSeUXWeG"
#}
#
#module "rds" {
#  source            = "../../modules/rds"
#  database_name     = "obi"
#  enviroment        = "dev"
#  database_user     = "superuser"
#  database_password = aws_secretsmanager_secret_version.db_password_secret_version.secret_string
#  subnet_ids         = ["subnet-05817cc08c4c95490", "subnet-0c23826ed22f9bec4", "subnet-0446f595633fdd966"] # to su private subnety
#  security_group_ids = ["sg-0262c7593c2382f27"]                                                             # to je nat instance - len pre test
#}