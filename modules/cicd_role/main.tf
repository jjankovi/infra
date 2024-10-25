resource "aws_iam_role" "cicd_role" {
  name                = "CICD-${var.project_name}-role"
  assume_role_policy  = data.aws_iam_policy_document.assume_policy_document.json
}

resource "aws_iam_role_policy_attachment" "cicd_role_policy_attach" {
  role       = aws_iam_role.cicd_role
  policy_arn = aws_iam_policy.cicd_role_policy.arn
}

resource "aws_iam_role_policy_attachment" "crossaccount_assume_policy_attach" {
  role       = aws_iam_role.cicd_role
  policy_arn = aws_iam_policy.allow_crossaccount_assume.arn
}

data "aws_iam_policy_document" "assume_policy_document" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = "codebuild.amazonaws.com"
    }
  }
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = "codepipeline.amazonaws.com"
    }
  }
}

resource "aws_iam_policy" "allow_crossaccount_assume" {
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
    for role in var.cicd_crossaccount_roles : {
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Resource = role
    }
    ]
  })
}

resource "aws_iam_policy" "cicd_role_policy" {
  name        = "CICD-${var.project_name}-policy"
  description = "Policy for CICD ${var.project_name} role"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetBucketVersioning",
        "s3:Get*",
        "s3:List*",
        "s3:ReplicateObject",
        "s3:PutObject",
        "s3:RestoreObject",
        "s3:PutObjectVersionTagging",
        "s3:PutObjectTagging",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "${var.artifacts_bucket_arn}",
        "${var.artifacts_bucket_arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
         "kms:DescribeKey",
         "kms:GenerateDataKey*",
         "kms:Encrypt",
         "kms:ReEncrypt*",
         "kms:Decrypt"
      ],
      "Resource": "${var.kms_key_arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codestar-connections:UseConnection"
      ],
      "Resource": "${var.codestar_connection_arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild",
        "codebuild:BatchGetProjects"
      ],
      "Resource": "arn:aws:codebuild:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:project/${var.project_name}*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:CreateReportGroup",
        "codebuild:CreateReport",
        "codebuild:UpdateReport",
        "codebuild:BatchPutTestCases"
      ],
      "Resource": "arn:aws:codebuild:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:report-group/${var.project_name}*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:*"
    }
  ]
}
EOF
}