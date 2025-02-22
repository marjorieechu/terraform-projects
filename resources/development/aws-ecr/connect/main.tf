
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
    key            = "connect/ecr/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "development-webfox-tf-state-lock"
  }
}

provider "aws" {
  region = local.env.region.dev
}

module "ecr" {
  source               = "../../../../modules/aws-ecr"
  aws_region           = local.env.region.dev
  force_delete         = local.env.ecr.force_delete
  ecr_repository_names = local.env.ecr.ecr_repository_names
  tags                 = local.env.tags
}