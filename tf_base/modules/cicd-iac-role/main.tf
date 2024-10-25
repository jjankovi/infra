resource "aws_iam_role" "cicd_role" {
  name                = "CICD-${var.project_name}-iac-role"
  assume_role_policy  = data.aws_iam_policy_document.pipeline_terraform_assume_policy_document.json
}

data "aws_iam_policy_document" "pipeline_terraform_assume_policy_document" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = "codebuild.amazonaws.com"
    }
  }
}