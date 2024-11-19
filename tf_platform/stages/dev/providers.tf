terraform {
  backend "s3" {
    key     = "eks_platform.dev.terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = var.region
}


