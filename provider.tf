terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.58.0"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "3.7.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "gitlab" {}
