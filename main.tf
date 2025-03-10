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
  region = "us-east-1"
}

resource "aws_s3_bucket" "static-s3-site" {
  bucket = variable.bucket_name
  region = variable.region

  tags = {
    Environment = variable.environment
  }
}