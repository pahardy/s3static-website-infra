# static-s3website-infra



## Purpose

This repository implements an S3 bucket and CloudFront distribution to serve the static S3 bucket website implemented in repository https://github.com/pahardy/s3static-website-code. It creates an S3 bucket in the `us-east-1` region in order to be able to use a custom TLS certificate for a CloudFront distribution, which it also implements. 

The repository also includes a GitLab pipeline file `.gitlab-ci.yml` in order to automatically make changes to the implementation if the Terraform code is amended.

## Obtain the files

```
git clone https://github.com/pahardy/s3static-website-infra
```

## Usage
The `main.tf` file can be used itself, or a GitLab pipeline can be configured to push changes to AWS when changes to the main branch are committed. 

To run it by itself: 

```
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

To use the deployment in a CI/CD manner, create a repository for it in GitLab,then commit any changes. This will require a GitLab runner.

