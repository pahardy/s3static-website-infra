variable "bucket_name" {
    description = "Name of the bucket hosting the site"
    type = string
    default = "statics3sitemarch17tf2"
}

variable "environment" {
    description = "Name of the environment"
    type = string
    default = "Prod"
}

