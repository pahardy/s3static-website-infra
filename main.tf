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
  bucket = "statics3sitemarch10tf"

  tags = {
    Environment = "Prod"
  }
}

#Create a CloudFront Origin Access Control configuration
#resource "aws_cloudfront_origin_access_control" "s3_static_cloudfront_oac" {
#  name                              = "s3_static_oac"
#  description                       = "Policy for CloudFront with S3 source"
#  origin_access_control_origin_type = "s3"
#  signing_behavior                  = "always"
#  signing_protocol                  = "sigv4"
#}

#Create a CloudFront distribution
#resource "aws_cloudfront_distribution" "s3_distribution" {
#  origin {
#    domain_name              = aws_s3_bucket.static-s3-site.bucket_regional_domain_name
#    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
#    origin_id                = local.s3_origin_id
#  }