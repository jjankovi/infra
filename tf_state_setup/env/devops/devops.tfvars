state_bucket         = "obi-devops-terraform-state"
state_lock_table = "obi-devops-terraform-state-lock"

terraform_provider_role = "arn:aws:iam::248189918720:role/obi-devops-terraform-role"
state_access_iam_roles = ["arn:aws:iam::248189918720:role/obi-devops-terraform-role"]
