// TODO
output "fargate_app_role_arn" {
  value       = aws_iam_role.fargate_app.arn
  description = "IAM role associated with Fargate app profile"
}
