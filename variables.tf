variable "bucket_name" {
    description = "Name of the S3 bucket that will host the static site"
    type = string
    default = "s3staticwebmarch10tf"
}

variable "region" {
    description = "Region required to set up the S3 bucket"
    type = string
    default = "us-east-1"
}

variable "environment" {
    description = "Org environment for the S3 bucket hosting the static website"
    type = string
    default = "Prod"
}


