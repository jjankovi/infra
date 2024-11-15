data "aws_vpc" "default" {
  default = true
}

resource "aws_vpc_endpoint" "ecr" {
  vpc_id       = data.aws_vpc.default.id
  service_name = "com.amazonaws.${var.region}.ecr.api"
  subnet_ids   = var.private_subnet_ids

  security_group_ids = var.security_group_ids
}

resource "aws_vpc_endpoint" "cloudwatch" {
  vpc_id       = data.aws_vpc.default.id
  service_name = "com.amazonaws.${var.region}.monitoring"
  subnet_ids   = var.private_subnet_ids

  security_group_ids = var.security_group_ids
}

module "cicd_ecr_repo" {
  source = "../../../modules/ecr"
  project_name = var.cicd_ecr_repo_name
}