locals {
  app_service_account_name = "${module.label.id}-sa"
  oidc_provider_id = "${replace(aws_eks_cluster.this.identity.0.oidc.0.issuer, "https://", "")}"
}