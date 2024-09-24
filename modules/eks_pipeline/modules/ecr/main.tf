resource "aws_ecr_repository" "ecr_repo" {
  name                 = "${var.project_name}-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_iam_policy" "ecr_repo_policy" {
  name        = "${var.project_name}-image-repo-custom-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "ecr:GetAuthorizationToken",
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = "ecr:*",
        Resource = "${aws_ecr_repository.ecr_repo.arn}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attach" {
  role       = var.cicd_role_name
  policy_arn = aws_iam_policy.ecr_repo_policy.arn
}