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
    key            = "webfox/eks-control-plane/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "development-webfox-tf-state-lock"
  }
}

provider "aws" {
  region = local.env.region.dev
}

module "eks-control-plane" {
  source                  = "../../../modules/eks-control-plane"
  aws_region              = local.env.region.dev
  eks_version             = local.env.eks.control-plane.eks_version
  endpoint_private_access = local.env.eks.control-plane.endpoint_private_access
  endpoint_public_access  = local.env.eks.control-plane.endpoint_public_access
  public_subnets          = local.env.vpc.public_subnets
  tags                    = local.env.tags
}