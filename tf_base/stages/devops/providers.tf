terraform {
  backend "s3" {
    key     = "base.terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = data.aws_region.current.id
  assume_role {
    role_arn = var.terraform_provider_role
  }
}