data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_s3_object" "codebuild_specs_data" {
  depends_on = [
    aws_s3_object.codebuild_specs
  ]
  for_each = toset([for project in local.codebuild_project_config : project.name])
  bucket   = module.codebuild_spec_bucket.bucket
  key      = "buildspec_${each.key}.yml"
}

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

data "terraform_remote_state" "dev_obi" {
  backend = "s3"
  config = {
    bucket         = "csob-dev-terraform-state"
    dynamodb_table = "csob-dev-terraform-state-lock"
    key            = "obi_eks.terraform.tfstate"
    encrypt        = true
    region         = "eu-central-1"
  }
}