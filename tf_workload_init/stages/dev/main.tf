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

data "aws_iam_policy" "admin_access" {
  name = "AdministratorAccess"
}

data "aws_iam_policy_document" "cicd_role_assume_policy_document" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [data.terraform_remote_state.devops_tier0.outputs.cicd_role_arn]
    }
  }
}

resource "aws_iam_role" "cicd_workload_role" {
  name                = "CICDPipelineWorkloadRole"
  assume_role_policy  = data.aws_iam_policy_document.cicd_role_assume_policy_document.json
  managed_policy_arns = [data.aws_iam_policy.admin_access.arn]
}


