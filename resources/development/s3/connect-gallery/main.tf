
locals {
  env = merge(
    yamldecode(file("${path.module}/../../../../environments/region.yaml")),
    yamldecode(file("${path.module}/../../../../environments/dev-connect.yaml"))
  )
}

terraform {
  required_version = ">= 1.10.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "development-webfox-tf-state"
    key            = "connect/s3/connect-gallery/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "development-webfox-tf-state-lock"
  }
}

provider "aws" {
  region = local.env.region.dev
}

module "s3-basic" {
  source      = "../../../../modules/s3-basic"
  aws_region  = local.env.region.dev
  bucket_name = local.env.s3.gallery.bucket_name
  tags        = local.env.tags
}