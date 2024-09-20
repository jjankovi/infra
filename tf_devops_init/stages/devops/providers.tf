terraform {
  backend "s3" {
    key     = "tier0.init.terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.devops_role_arn
  }
}