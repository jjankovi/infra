state_bucket         = "obi-prod-terraform-state"
state_lock_table = "obi-prod-terraform-state-lock"

terraform_provider_role = "arn:aws:iam::248189918720:role/obi-devops-terraform-role"
state_access_iam_roles = [
  "arn:aws:iam::954976319120:role/obi-prod-terraform-role",
  "arn:aws:iam::954976319120:role/obi-prod-codebuild-role"
]