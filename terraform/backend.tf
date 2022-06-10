# This file is responsible for linking the cloud providers with your credential stores, and downloading 
# the terraform binaries needed to execute the "plan"

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  region = "us-east-1"

  shared_credentials_files = ["../.env/credentials"]
  profile                  = "default"
}
