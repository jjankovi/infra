state_bucket         = "obi-dev-terraform-state"
state_lock_table = "obi-dev-terraform-state-lock"

terraform_provider_role = "arn:aws:iam::248189918720:role/obi-devops-terraform-role"
state_access_iam_roles = [
  "arn:aws:iam::225989357007:role/obi-dev-terraform-role",
  "arn:aws:iam::225989357007:role/obi-dev-codebuild-role"
]