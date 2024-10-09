resource "aws_iam_role" "pipeline_role" {
  name                = "${var.project_name}-${var.enviroment}-pipeline-role"
  assume_role_policy  = data.aws_iam_policy_document.pipeline_terraform_assume_policy_document.json
}

data "aws_iam_policy_document" "pipeline_terraform_assume_policy_document" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = "codepipeline.amazonaws.com"
    }
  }
}