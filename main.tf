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