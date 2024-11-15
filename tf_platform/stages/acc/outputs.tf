output "fargate_role_arn" {
  value = module.eks_cluster.fargate_app_role_arn
}