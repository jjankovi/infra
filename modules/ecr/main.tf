resource "aws_ecr_repository" "ecr_repo" {
  name                 = "${var.project_name}-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_iam_policy_document" "ecr_policy_doc" {
  statement {
    sid    = "Full access policy"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.full_access_roles
    }

    actions = [
      "ecr:*"
    ]
  }
  dynamic "statement" {
    for_each = length(var.read_access_roles) > 0 ? [1] : []
    content {
      sid    = "Read access policy"
      effect = "Allow"
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
      principals {
        type        = "AWS"
        identifiers = var.read_access_roles
      }
    }
  }
}

resource "aws_ecr_repository_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr_repo.name
  policy     = data.aws_iam_policy_document.ecr_policy_doc.json
}