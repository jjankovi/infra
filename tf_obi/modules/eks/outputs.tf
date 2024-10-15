output "fargate_role_arn" {
  value       = aws_iam_role.eks_fargate_role.arn
  description = "IAM role associated with Fargate profile"
}