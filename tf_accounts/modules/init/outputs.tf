
output "bucket" {
  value       = aws_s3_bucket.state_bucket.id
  description = "S3 bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.state_bucket.arn
  description = "S3 bucket arn"
}

output "dynamodb_table_arn" {
  value       = aws_dynamodb_table.state_lock_table.arn
  description = "DynamoDB table arn"
}