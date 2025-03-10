#Create S3 bucket to host the static website

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
  region = variable.region
}

resource "aws_s3_bucket" "static-s3-site" {
  bucket = variable.bucket_name
  region = variable.region

  tags = {
    Name        = "StaticSiteBucket"
    Environment = variable.environment
  }
}