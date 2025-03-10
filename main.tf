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
  bucket = "statics3sitemarch10tf"
  region = "us-east-1"

  tags = {
    Environment = variable.environment
  }
}