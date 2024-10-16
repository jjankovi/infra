output "key_arn" {
  value       = join("", aws_kms_key.encryption_key.*.arn)
  description = "Key ARN"
}

output "key_id" {
  value       = join("", aws_kms_key.encryption_key.*.key_id)
  description = "Key ID"
}

#output "alias_arn" {
#  value       = join("", aws_kms_alias.default.*.arn)
#  description = "Alias ARN"
#}
#
#output "alias_name" {
#  value       = join("", aws_kms_alias.default.*.name)
#  description = "Alias name"
#}