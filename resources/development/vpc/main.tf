
locals {
  env = merge(
    yamldecode(file("${path.module}/../../../environments/region.yaml")),
    yamldecode(file("${path.module}/../../../environments/dev-webforx.yaml"))
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
    key            = "webforx/vpc/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "development-webfox-tf-state-lock"
  }
}

provider "aws" {
  region = local.env.region.dev
}

module "vpc" {
  source               = "../../../modules/vpc"
  aws_region           = local.env.region.dev
  availability_zones   = local.env.vpc.availability_zones
  cidr_block           = local.env.vpc.cidr_block
  control_plane_name   = local.env.eks.control-plane.control_plane_name
  enable_dns_support   = local.env.vpc.enable_dns_support
  enable_dns_hostnames = local.env.vpc.enable_dns_hostnames
  tags                 = local.env.tags
}