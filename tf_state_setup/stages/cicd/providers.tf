terraform {
  backend "s3" {
    key     = "tf-state-setup.cicd.terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = var.region
}