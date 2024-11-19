module "eks_cluster" {
  source          = "../../modules/eks"
  aws_namespace   = var.aws_namespace
  aws_environment = var.aws_environment
  aws_component   = var.aws_component
  aws_attributes  = var.aws_attributes


  k8s_app_namespace  = var.k8s_app_namespace
  eks_admin_roles    = var.eks_admin_roles
  private_subnet_ids = var.private_subnet_ids
}