
output "bucket" {
  value       = aws_s3_bucket.default.id
  description = "S3 bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.default.arn
  description = "S3 bucket arn"
}

output "bucket_region" {
  value       = aws_s3_bucket.default.region
  description = "S3 bucket region"
}
