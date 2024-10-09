resource "aws_iam_role" "pipeline_terraform_role" {
  name                = "${var.project_name}-${var.enviroment}-pipeline-terraform-role"
  assume_role_policy  = data.aws_iam_policy_document.pipeline_terraform_assume_policy_document.json
}

resource "aws_iam_role_policy_attachment" "pipeline_terraform_policy_attachment" {
  policy_arn = aws_iam_policy.pipeline_terraform_policy.arn
  role       = aws_iam_role.pipeline_terraform_role.name
}

data "aws_iam_policy_document" "pipeline_terraform_assume_policy_document" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.assumable_by_pipeline_terraform_role
    }
  }
}

resource "aws_iam_policy" "pipeline_terraform_policy" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "eks:*"
        Resource = ["*"]
      }
    ]
  })
}

