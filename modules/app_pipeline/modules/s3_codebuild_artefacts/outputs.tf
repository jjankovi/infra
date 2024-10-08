
output "arn" {
  value       = module.codepipeline_bucket.bucket_arn
  description = "The ARN of the S3 Bucket"
}

output "bucket" {
  value       = module.codepipeline_bucket.bucket
  description = "The Name of the S3 Bucket"
}

output "bucket_url" {
  value       = "https://s3.console.aws.amazon.com/s3/buckets/${module.codepipeline_bucket.bucket}?region=${module.codepipeline_bucket.bucket_region}&tab=objects"
  description = "The URL of the S3 Bucket"
}
