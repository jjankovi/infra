data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
#data "aws_vpc" "default" {
#  default = true
#}

data "tls_certificate" "oidc_tls_certificate" {
  depends_on = [
    aws_eks_cluster.this
  ]
  url = aws_eks_cluster.this.identity.0.oidc.0.issuer
}