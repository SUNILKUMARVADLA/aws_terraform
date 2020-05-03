output "s3_origin_id" {
  value = local.s3_origin_id
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.tf_bucket.bucket_regional_domain_name
}

output "bucket_id" {
  value = aws_s3_bucket.tf_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.tf_bucket.arn
}