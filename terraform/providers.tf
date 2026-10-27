terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile

  # Every resource Terraform creates gets these tags automatically
  default_tags {
    tags = {
      owner   = var.owner
      project = var.project
    }
  }
}