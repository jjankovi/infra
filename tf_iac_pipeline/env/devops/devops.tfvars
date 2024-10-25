project_name = "obi"
environment = "devops"
terraform_provider_role = "arn:aws:iam::248189918720:role/OBI-OPERATOR-L3"

source_repo = {
  id             = "jjankovi/obi-iac",
  connection_arn = "arn:aws:codeconnections:eu-central-1:058264153756:connection/2fa2ed0c-0d42-4730-aaac-8b8453acbf44",
  branch         = "main"
}