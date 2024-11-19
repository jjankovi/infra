resource "aws_eks_fargate_profile" "kube" {
  cluster_name = aws_eks_cluster.this.name
  fargate_profile_name = "${module.label.id}-kube-profile"
  tags = module.label.tags

  pod_execution_role_arn = aws_iam_role.fargate_kube.arn

  subnet_ids = var.private_subnet_ids

  selector {
    namespace = "kube-system"
  }
}

resource "aws_eks_fargate_profile" "app" {
  depends_on = [
    kubernetes_namespace.app_namespace
  ]
  cluster_name = aws_eks_cluster.this.name
  fargate_profile_name = "${module.label.id}-app-profile"
  tags = module.label.tags

  pod_execution_role_arn = aws_iam_role.fargate_app.arn

  subnet_ids = var.private_subnet_ids

  selector {
    namespace = kubernetes_namespace.app_namespace.id
  }
}

data "aws_iam_policy_document" "fargate_cloudwatch_policy_doc" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:PutRetentionPolicy"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "fargate_cloudwatch_policy" {
  policy      = data.aws_iam_policy_document.fargate_cloudwatch_policy_doc.json
}

resource "aws_iam_role" "fargate_kube" {
  name = "${module.label.id}-eks-fargate-kube-role"
  tags = module.label.tags
  assume_role_policy  = data.aws_iam_policy_document.fargate_kube_assume_doc.json
}

data "aws_iam_policy_document" "fargate_kube_assume_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = [
        "eks-fargate-pods.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "fargate_kube_cloudwatch_policy" {
  role       = aws_iam_role.fargate_kube.name
  policy_arn = aws_iam_policy.fargate_cloudwatch_policy.arn
}

resource "aws_iam_role_policy_attachment" "fargate_kube_pod_execution_policy" {
  role       = aws_iam_role.fargate_kube.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}

resource "aws_iam_role" "fargate_app" {
  name = "${module.label.id}-eks-fargate-app-role"
  tags = module.label.tags
  assume_role_policy  = data.aws_iam_policy_document.fargate_app_assume_doc.json
}

data "aws_iam_policy_document" "fargate_app_assume_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = [
        "eks-fargate-pods.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "fargate_app_cloudwatch_policy" {
  role       = aws_iam_role.fargate_app.name
  policy_arn = aws_iam_policy.fargate_cloudwatch_policy.arn
}

resource "aws_iam_role_policy_attachment" "fargate_app_pod_execution_policy" {
  role       = aws_iam_role.fargate_app.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}