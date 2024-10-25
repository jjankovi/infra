resource "aws_iam_openid_connect_provider" "this" {
  depends_on = [
    data.tls_certificate.oidc_tls_certificate
  ]
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc_tls_certificate.certificates.0.sha1_fingerprint]
  url = aws_eks_cluster.this.identity.0.oidc.0.issuer
}