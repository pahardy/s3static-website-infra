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
  bucket = aws_s3_bucket.static-s3-site

  index_document {
    suffix = "index.html"
  }
}


data "aws_acm_certificate" "acm_cert" {
  domain   = "pahardy.com" # Replace with your domain
  statuses = ["ISSUED"]
  most_recent = true
}

resource "aws_cloudfront_distribution" "s3_static_distribution" {
  origin {
    domain_name              = aws_s3_bucket.static-s3-site.bucket_regional_domain_name
    origin_id                = "myS3origin"
  }

  aliases = ["sdelements.pahardy.com"]
  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }
  
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for static website hosted in S3"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.static-s3-site
    prefix          = "myprefix"
  }

  # Use the ACM certificate for HTTPS
  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.acm_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

