# CloudFront distribution for S3 content delivery
resource "aws_cloudfront_distribution" "cf_s3_distribution" {
  depends_on       = [aws_s3_bucket.startup_image_bucket]
  retain_on_delete = true
  
  origin {
    domain_name              = aws_s3_bucket.startup_image_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac-s3.id
    origin_id                = "${var.s3_name}-origin"
  }

  enabled         = true
  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "DELETE", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.s3_name}-origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# Origin Access Control for secure S3 access
resource "aws_cloudfront_origin_access_control" "oac-s3" {
  name                              = aws_s3_bucket.startup_image_bucket.id
  description                       = "OAC for S3 bucket ${aws_s3_bucket.startup_image_bucket.id}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


