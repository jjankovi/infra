resource "aws_ecr_repository" "ecr_repo" {
  name                 = "${var.project_name}-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_iam_policy" "full_access_policy" {
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

resource "aws_iam_role_policy_attachment" "full_access_policy_attach" {
  for_each = var.full_access_roles

  role    = each.key
  policy_arn = aws_iam_policy.full_access_policy.arn
}

data "aws_iam_policy_document" "workload_accounts_policy_doc" {
  statement {
    sid    = "new policy"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.read_access_roles
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:ListTagsForResource",
      "ecr:DescribeImageScanFindings"
    ]
  }
}

resource "aws_ecr_repository_policy" "workload_accounts_policy" {
  repository = aws_ecr_repository.ecr_repo.name
  policy     = data.aws_iam_policy_document.workload_accounts_policy_doc.json
}