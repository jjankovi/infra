#resource "aws_acm_certificate" "alb_cert" {
#  domain_name       = "example.com"
#  validation_method = "DNS"
#
#  tags = {
#    Environment = "test"
#  }
#
#  lifecycle {
#    create_before_destroy = true
#  }
#}

resource "kubernetes_ingress_v1" "app_ingress" {
  depends_on = [
    helm_release.aws_lb_controller,
    aws_eks_fargate_profile.fargate_profile,
    aws_iam_openid_connect_provider.cluster
  ]
  metadata {
    name        = "${var.project_name}-ingress"
    namespace   = kubernetes_namespace.eks_namespace.id
    annotations = {
      "kubernetes.io/ingress.class"                        = "alb"
      "alb.ingress.kubernetes.io/scheme"                   = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"              = "ip"
      "alb.ingress.kubernetes.io/load-balancer-attributes" = "deletion_protection.enabled=false"
      "alb.ingress.kubernetes.io/subnets"                  = local.public_subnet_ids
      "alb.ingress.kubernetes.io/healthcheck-path"         = "/"
      "alb.ingress.kubernetes.io/healthcheck-interval-seconds" = "10"
      "alb.ingress.kubernetes.io/healthcheck-timeout-seconds" = "3"
      "alb.ingress.kubernetes.io/healthcheck-port" = "8080"
      "alb.ingress.kubernetes.io/target-group-attributes" = "deregistration_delay.timeout_seconds=10"
      "alb.ingress.kubernetes.io/healthy-threshold-count" =  "2"
      "alb.ingress.kubernetes.io/unhealthy-threshold-count" = "3"
#      "alb.ingress.kubernetes.io/listen-ports"= "[{\"HTTPS\":443}]",
#      "alb.ingress.kubernetes.io/load-balancer-attributes"= "access_logs.s3.enabled=true,access_logs.s3.bucket=digion-uat-logs,access_logs.s3.prefix=alb/albexternal",
#      "alb.ingress.kubernetes.io/ssl-policy"= "ELBSecurityPolicy-TLS13-1-2-2021-06",
#      "alb.ingress.kubernetes.io/certificate-arn"= "arn:aws:acm:eu-central-1:585023840366:certificate/cf10319b-578e-4e5d-9d4d-5cf92598e7fb",
#      "alb.ingress.kubernetes.io/wafv2-acl-arn"= "arn:aws:wafv2:eu-central-1:585023840366:regional/webacl/digion-uat-shared-acl/34217baf-a15d-4aff-8cf6-5d0d4be9ca3f",
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/*"
          backend {
            service {
              name = var.project_name
              port {
                number = var.k8s_app_port
              }
            }
          }
        }
      }
    }
  }
}