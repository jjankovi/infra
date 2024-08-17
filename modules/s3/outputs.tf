
output "bucket" {
  value       = aws_s3_bucket.new_bucket.id
  description = "S3 bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.new_bucket.arn
  description = "S3 bucket arn"
}

output "bucket_region" {
  value       = aws_s3_bucket.new_bucket.region
  description = "S3 bucket region"
}
