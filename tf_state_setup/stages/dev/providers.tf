terraform {
  backend "s3" {
    key     = "tf-state-setup.dev.terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.terraform_provider_role
  }
}