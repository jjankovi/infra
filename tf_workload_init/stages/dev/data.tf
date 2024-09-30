data "terraform_remote_state" "devops_tier0" {
  backend = "s3"
  config = {
    bucket         = "csob-devops-terraform-state"
    dynamodb_table = "arn:aws:dynamodb:eu-central-1:058264153756:table/csob-devops-terraform-state-lock"
    key            = "tier0.init.terraform.tfstate"
    encrypt        = true
    region         = "eu-central-1"
  }
}