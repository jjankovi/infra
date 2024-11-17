data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region = data.aws_region.current.id
}

resource "aws_kms_key" "state_lock_table_key" {
  description             = "This key is used to encrypt dynamodb tables"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_alias" "state_lock_table_key_alias" {
  name          = "alias/${var.state_dynamodb_table_name}-key-alias"
  target_key_id = aws_kms_key.state_lock_table_key.id
}

resource "aws_kms_key_policy" "state_lock_table_kms_access" {
  key_id = aws_kms_key.state_lock_table_key.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid": "Default permission for root user",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::058264153756:root"
        },
        "Action": ["kms:*"],
        "Resource": "*"
      },
      {
        "Sid": "Default permission for L3 role",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::058264153756:role/obi-devops-terraform-role"
        },
        "Action": ["kms:*"],
        "Resource": "*"
      },
      {
        "Sid": "Permission for basic operator role",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::058264153756:user/Administrator"
        },
        "Action": ["kms:Decrypt"],
        "Resource": "*"
      }
    ]
  })
}
