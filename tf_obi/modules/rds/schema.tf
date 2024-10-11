resource "aws_lambda_function" "test_lambda" {
  function_name = "schema_handler"
  handler       = "schema_handler.lambda_handler"
  filename      = "${path.module}/schema_handler.py.zip"
  role          = aws_iam_role.iam_for_lambda.arn

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.9"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/schema_handler.py"
  output_path = "${path.module}/schema_handler.py.zip"
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "schema_handler_execution_role"
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

resource "aws_iam_policy" "lambda_logging_policy" {
  name        = "lambda_logging_policy"
  description = "Policy to allow Lambda to write logs to CloudWatch"
  policy      = data.aws_iam_policy_document.logging_policy.json
}

data "aws_iam_policy_document" "logging_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging_policy.arn
}

data "aws_lambda_invocation" "test_lambda_invocation" {
  function_name = aws_lambda_function.test_lambda.function_name
  input         = jsonencode(var.schemas)
}