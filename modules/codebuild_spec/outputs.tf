
output "bucket" {
  value       = module.buildspec_bucket.bucket
  description = "S3 bucket that stores buildSpec templates"
}