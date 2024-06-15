# output "s3_bucket_id" {
#   description = "The name of the bucket."
#   value       = try(aws_s3_bucket_policy.bucket_tmp.id, aws_s3_bucket.bucket_tmp.id, "")
# }

output "s3_bucket_id" {
  description = "The name of the bucket."
  value       = try(aws_s3_bucket.bucket_tmp.id, "")
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = try(aws_s3_bucket.bucket_tmp.arn, "")
}
output "bucket_regional_domain_name" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = try(aws_s3_bucket.bucket_tmp.bucket_regional_domain_name, "")
}