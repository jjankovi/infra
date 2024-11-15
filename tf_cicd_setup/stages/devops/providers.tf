terraform {
  backend "s3" {
    key     = "cicd_setup.terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.terraform_provider_role
  }
}

