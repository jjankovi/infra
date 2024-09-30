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


