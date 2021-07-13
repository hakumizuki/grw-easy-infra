terraform {
  backend "s3" {
    bucket         = var.s3_bucket_name
    key            = "growi-easy.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = var.dynamodb_table_name
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.25.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

locals {
  prefix = "${var.prefix}-${terraform.workspace}"
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    MannagedBy  = "Terraform"
  }
  # Network part for VPC cidr block (set this to avoid conflicts)
  vpc_cidr_network = var.vpc_cidr_network
}

# Retrieve current region to avoid hard coding
data "aws_region" "current" {}
