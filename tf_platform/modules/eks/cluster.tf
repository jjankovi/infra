resource "aws_eks_cluster" "this" {
  name     = module.label.id
  tags = module.label.tags
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }
}

resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = var.k8s_app_namespace
  }
}

resource "aws_iam_role" "eks_cluster" {
  name = "${module.label.id}-eks-cluster-role"
  assume_role_policy  = data.aws_iam_policy_document.eks_cluster_assume_doc.json
  tags = module.label.tags
}

data "aws_iam_policy_document" "eks_cluster_assume_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = [
        "eks.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}