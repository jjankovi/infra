resource "aws_eks_access_entry" "eks_admin_access_entry" {
  for_each = toset(var.eks_admin_roles)

  cluster_name = aws_eks_cluster.this.name
  principal_arn = each.key
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks_admin_policy_association" {
  depends_on = [
    aws_eks_access_entry.eks_admin_access_entry
  ]
  for_each = toset(var.eks_admin_roles)

  cluster_name  = aws_eks_cluster.this.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = each.key

  access_scope {
    type       = "cluster"
  }
}