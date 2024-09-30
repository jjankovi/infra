data "aws_iam_policy_document" "app_deployer_role_assume_policy_document" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [data.terraform_remote_state.devops_tier0.outputs.cicd_role_arn]
    }
  }
}

resource "aws_iam_role" "app_deployer_role" {
  name               = "AppDeployerRole"
  assume_role_policy = data.aws_iam_policy_document.app_deployer_role_assume_policy_document.json
}

resource "aws_iam_policy" "deployer_eks_policy" {
  name = "EKSDeployerPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "eks:DescribeCluster"
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_policy_attachment" {
  policy_arn = aws_iam_policy.deployer_eks_policy.arn
  role       = aws_iam_role.app_deployer_role.name
}