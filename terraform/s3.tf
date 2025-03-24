# Main S3 bucket for image storage
resource "aws_s3_bucket" "startup_image_bucket" {
  bucket        = var.s3_name
  force_destroy = true
}

# Bucket policy restricting access to CloudFront only
resource "aws_s3_bucket_policy" "startup_image_bucket_policy" {
  bucket = aws_s3_bucket.startup_image_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.startup_image_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.cf_s3_distribution.id}"
          }
        }
      }
    ]
  })
}