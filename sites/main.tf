terraform {
  backend "s3" {
    bucket = var.backend_bucket
    key    = var.backend_bucket_key
    region = var.aws_region
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    onepassword = {
      source  = "1password/onepassword"
      version = "3.1.1"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      project = "sites"
      repo    = "https://github.com/curtdmiller/infra-personal"
    }
  }
}

provider "onepassword" {
  account = var.onepassword_account
}