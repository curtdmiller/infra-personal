variable "backend_bucket" {
  description = "s3 bucket where state is stored"
  type        = string
}

variable "backend_bucket_key" {
  description = "s3 key where state is stored"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "onepassword_account" {
  description = "1Password account"
  type        = string
}

variable "onepassword_key_vault" {
  description = "1Password vault for SSH keys"
  type        = string
}

variable "onepassword_ssh_key_uuid" {
  description = "UUID of the SSH key item in 1Password"
  type        = string
}