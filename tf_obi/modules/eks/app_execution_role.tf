# Kubernetes service account for the application
resource "kubernetes_service_account" "application_sa" {
  metadata {
    name      = local.app_service_account_name
    namespace = var.k8s_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.app_execution_role.arn
    }
  }
}

# IAM execution role for the application
resource "aws_iam_role" "app_execution_role" {
  name = "${var.project_name}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider_id}"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      "Condition": {
        "StringEquals": {
          "${local.oidc_provider_id}:sub": "system:serviceaccount:${var.k8s_namespace}:${local.app_service_account_name}"
        }
      }
    }]
  })
}

# Access to parameter store for application
resource "aws_iam_policy" "ssm_parameter_policy" {
  name   = "${var.project_name}-ssm-parameter-access"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ],
        "Resource": "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/app/${var.project_name}/*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ssm:GetParametersByPath"
        ],
        "Resource": "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/app/${var.project_name}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy_to_role" {
  role       = aws_iam_role.app_execution_role.name
  policy_arn = aws_iam_policy.ssm_parameter_policy.arn
}