locals {
  app_service_account_name = "${var.project_name}-sa"
  oidc_provider_id = "${replace(aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer, "https://", "")}"
}