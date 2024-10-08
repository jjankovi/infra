terraform {
  backend "s3" {
    key     = "obi_eks.terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.workload_role_arn
  }
}


