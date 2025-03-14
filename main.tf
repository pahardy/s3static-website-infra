terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#Create an S3 bucket
resource "aws_s3_bucket" "static-s3-site" {
  bucket = "statics3sitemarch11tf"

  tags = {
    Environment = "Prod"
  }
}

#Create bucket policy to allow CloudFront to access it
resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.static-s3-site.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.static-s3-site.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}

#Create a CloudFront Origin Access Control configuration
resource "aws_cloudfront_origin_access_control" "s3_static_cloudfront_oac" {
  name                              = "s3_static_oac"
  description                       = "Policy for CloudFront with S3 source"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

#Create a CloudFront distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.static-s3-site.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_static_cloudfront_oac.id
    origin_id                = "myOriginId"
  }

  enabled = true
  default_root_object = "index.html"

  aliases = ["sdelements.pahardy.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myOriginId"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:862980915839:certificate/3519496f-4902-43d0-8b12-7d0b1f3d5b4c"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

#Create a Route53 record to match the CloudFront Distribution 
resource "aws_route53_record" "example" {
  zone_id = aws_route53_zone.example.zone_id  # Hosted zone ID for pahardy.com
  name    = "sdelements.pahardy.com"                     # Custom domain name
  type    = "A"                               # Alias A record for CloudFront

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name  # CloudFront domain name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id  # CloudFront hosted zone ID
    evaluate_target_health = false
  }
}