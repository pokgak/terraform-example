terraform {
  cloud {
    organization = "pokgak-org"

    workspaces {
      name = "networking-staging"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "access_key" {}

variable "secret_key" {}

variable "region" {}


provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region

  default_tags {
    tags = {
      Environment = "staging"
      Owner       = "INFRA"
      Terraform   = "true"
    }
  }
}
