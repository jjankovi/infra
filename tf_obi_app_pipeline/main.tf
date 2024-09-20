terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.1"
    }
  }

  backend "s3" {
    bucket         = "csob-obi-terraform-state"
    dynamodb_table = "csob-obi-terraform-state-lock"
    key            = "obi_pipeline/devops"
    region         = "eu-central-1"
    encrypt        = true
  }

}

provider "aws" {
  region = "eu-central-1"
}

module pipeline {
  source = "../modules/eks_pipeline"
  project_name               = "obi"
  source_repo_connection_arn = doplnit // TODO JJA
  source_repo_id             = doplnit // TODO JJA
  source_repo_branch         = "main"

  target_accounts = [
    { environment = "dev", account = "396608792866", workload_role = "arn:aws:iam::396608792866:role/WorkloadRole" }
  ]
}