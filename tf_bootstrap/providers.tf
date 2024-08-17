terraform {
  backend "s3" {
    bucket         = "csob-obi-terraform-state"
    dynamodb_table = "csob-obi-terraform-state-lock"
    encrypt        = true
    region         = "eu-central-1"
  }
}
