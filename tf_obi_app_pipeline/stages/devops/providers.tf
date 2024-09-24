terraform {
  backend "s3" {
    key     = "obi_pipeline.terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.devops_role_arn
  }
}

