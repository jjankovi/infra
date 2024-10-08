#/* Kubernetes Deployment  */
#resource "kubernetes_deployment" "app" {
#  depends_on = [
#    aws_eks_fargate_profile.fargate_profile,
#    kubernetes_config_map.cloudwatch_config_map
#  ]
#  metadata {
#    name      = var.project_name
#    namespace = kubernetes_namespace.eks_namespace.id
#    labels = {
#      App = var.project_name
#    }
#  }
#
#  spec {
#    strategy {
#      type = "RollingUpdate"
#    }
#    replicas = var.k8s_replica_count
#
#    selector {
#      match_labels = {
#        App = var.project_name
#      }
#    }
#
#    template {
#      metadata {
#        labels = {
#          App = var.project_name
#        }
#      }
#      spec {
#        restart_policy = "Always"
#        service_account_name = local.app_service_account_name
#        container {
#          name  = var.project_name
#          image = "058264153756.dkr.ecr.eu-central-1.amazonaws.com/obi-repo:latest"
#          image_pull_policy = "Always"
#          port {
#            container_port = var.k8s_app_port
#          }
#          resources {
#            requests = {
#              cpu    = var.k8s_cpu
#              memory = var.k8s_memory
#            }
#
#            limits = {
#              cpu    = var.k8s_cpu_limit
#              memory = var.k8s_memory_limit
#            }
#          }
#        }
#      }
#    }
#  }
#}
#
#/* Kubernetes service */
#resource "kubernetes_service" "app_service" {
#  metadata {
#    name      = var.project_name
#    namespace = kubernetes_namespace.eks_namespace.id
#  }
#
#  spec {
#    selector = {
#      App = var.project_name
#    }
#    port {
#      port        = var.k8s_app_port
#      target_port = var.k8s_app_port
#    }
#    type = "ClusterIP"
#  }
#}