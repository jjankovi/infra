data "terraform_remote_state" "devops_tier0" {
  backend = "s3"
  config = {
    bucket         = "csob-devops-terraform-state"
    dynamodb_table = "csob-devops-terraform-state-lock"
    key            = "tier0.init.terraform.tfstate"
    encrypt        = true
    region         = "eu-central-1"
  }
}

data "terraform_remote_state" "dev_tier0" {
  backend = "s3"
  config = {
    bucket         = "csob-dev-terraform-state"
    dynamodb_table = "csob-dev-terraform-state-lock"
    key            = "tier0.init.terraform.tfstate"
    encrypt        = true
    region         = "eu-central-1"
  }
}