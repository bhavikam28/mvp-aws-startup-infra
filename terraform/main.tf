# Terraform Provider Block
terraform {
  required_providers {
      aws = {
      source  = "hashicorp/aws"
      version = "5.76.0"
    }
  }


  # Remote Backend Configuration
  backend "remote" {
    organization = "cloud-talents"

    workspaces {
      name = "fictitious-startup"
    }
  }
}

data "aws_caller_identity" "current" {}