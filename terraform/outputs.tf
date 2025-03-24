output "s3_bucket_name" {
  value = aws_s3_bucket.startup_image_bucket.bucket
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.cf_s3_distribution.id
}