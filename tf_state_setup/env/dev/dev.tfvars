aws_namespace = "csob"
aws_environment = "dev"
aws_component = "obi"
aws_attributes = ["tfstate"]
/* TODO JJA tu bude DEV OPERATOR / DEV CICD */
state_access_iam_roles = [
  "arn:aws:iam::248189918720:role/OBI-OPERATOR-L3",
  "arn:aws:iam::225989357007:role/OBI-OPERATOR-L3"
]