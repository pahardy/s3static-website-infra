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

resource "aws_s3_bucket" "static-s3-site" {
  bucket = "statics3sitemarch10tf"

  tags = {
    Environment = "Prod"
  }
}

resource "aws_s3_bucket_website_configuration" "s3_bucket_static_config" {
  bucket = "statics3sitemarch10tf"

  index_document {
    suffix = "index.html"
  }
}

data "aws_acm_certificate" "acm_cert" {
  domain   = "pahardy.com" # Replace with your domain
  statuses = ["ISSUED"]
  most_recent = true
}

# Create CloudFront Distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.static-s3-site.bucket_regional_domain_name
    origin_id                = "s3-origin"
  }

  enabled             = true
  default_root_object = "index.html"

  # Default cache behavior
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-origin"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # Price class (Use PriceClass_All for global coverage)
  price_class = "PriceClass_100"

  # Use an SSL certificate from ACM (Optional)
  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.acm_cert
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}