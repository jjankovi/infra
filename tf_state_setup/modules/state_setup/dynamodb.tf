resource "aws_dynamodb_table" "state_lock_table" {
  name     = var.state_dynamodb_table_name
  hash_key = "LockID"

  billing_mode = "PAY_PER_REQUEST"

  server_side_encryption {
    enabled = false
  }

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_dynamodb_resource_policy" "terraform_roles_state_lock_table_access" {
  resource_arn = aws_dynamodb_table.state_lock_table.arn
  policy       = data.aws_iam_policy_document.state_lock_table_access_roles.json
}

data "aws_iam_policy_document" "state_lock_table_access_roles" {
  statement {
    principals {
      type        = "AWS"
      identifiers = var.state_access_iam_roles
    }

    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:DeleteItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateItem"
    ]

    resources = [
      "${aws_dynamodb_table.state_lock_table.arn}"
    ]
  }
}