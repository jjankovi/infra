locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_kms_key" "encryption_key" {
  policy                  = data.aws_iam_policy_document.kms_key_policy_doc.json
  deletion_window_in_days  = var.deletion_window_in_days
  enable_key_rotation      = var.enable_key_rotation

  tags                    = var.tags
}

#resource "aws_kms_alias" "default" {
#  name          = var.alias
#  target_key_id = join("", aws_kms_key.encryption_key.*.id)
#}

data "aws_iam_policy_document" "kms_key_policy_doc" {

  dynamic "statement" {
    for_each = var.kms_root_access ? [1] : []

    content {
      sid     = "Enable full access to account root"
      effect  = "Allow"
      actions = ["kms:*"]
      resources = ["*"]
      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${local.account_id}:root"]
      }
    }
  }

  statement {
    sid    = "Allow use of the key"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = var.kms_access_roles
    }
  }
}
