resource "aws_lambda_function" "this" {
  function_name = "obi_schema_creator"
  handler       = "schema_creator.handler"
  filename      = "${path.module}/schema_creator.py.zip"
  role          = aws_iam_role.this.arn

  source_code_hash = data.archive_file.lambda_source.output_base64sha256

  runtime = "python3.9"

  environment {
    variables = {
      DB_HOST = "obi-dev-db.cbusa8eogesf.eu-central-1.rds.amazonaws.com"
      DB_NAME = "obi"
      DB_USER = "superuser"
      DB_PASSWORD = "vqUVyzeeBoIbrMHbkrSpYafGsGodLYEqmaXDovSAmTZSeUXWeG"
    }
  }
}

data "archive_file" "lambda_source" {
  type        = "zip"
  source_file = "${path.module}/schema_creator.py"
  output_path = "${path.module}/schema_creator.py.zip"
}

resource "aws_iam_role" "this" {
  name               = "obi_schema_creator_execution_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "logging_policy" {
  name        = "logging_policy"
  description = "Policy to allow Lambda to write logs to CloudWatch"
  policy      = data.aws_iam_policy_document.logging_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "lambda_logging_attach" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.logging_policy.arn
}

resource "aws_iam_policy" "rds_policy" {
  name        = "rds_policy"
  description = "Policy to allow Lambda to connect to RDS"
  policy      = data.aws_iam_policy_document.rds_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "rds_policy_attach" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.logging_policy.arn
}

data "aws_iam_policy_document" "logging_policy_doc" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "rds_policy_doc" {
  statement {
    actions = [
      "rds:*",
    ]
    resources = ["*"]
  }
}


#data "aws_lambda_invocation" "test_lambda_invocation" {
#  function_name = aws_lambda_function.this.function_name
#  input         = jsonencode(var.schemas)
#}