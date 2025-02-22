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
    key            = "webfox/eks-namespaces/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "development-webfox-tf-state-lock"
  }
}

provider "aws" {
  region = local.env.region.dev
}

module "eks-namespaces" {
  source             = "../../../modules/eks-namespaces"
  aws_region         = local.env.region.dev
  namespaces         = local.env.eks.namespaces
  control_plane_name = local.env.eks.control-plane.control_plane_name
  tags               = local.env.tags
}