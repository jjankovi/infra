module "eks_cluster" {
  source        = "../../modules/eks"
  project_name  = var.project_name
  environment    = var.environment
  k8s_app_namespace = var.k8s_app_namespace
  eks_admin_roles = var.eks_admin_roles
  private_subnet_ids = var.private_subnet_ids
}