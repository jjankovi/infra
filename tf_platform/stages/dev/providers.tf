terraform {
  backend "s3" {
    key     = "eks_platform.terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.terraform_role_arn
  }
}


