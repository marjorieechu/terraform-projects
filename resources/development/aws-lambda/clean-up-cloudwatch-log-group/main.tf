
locals {
  env = merge(
    yamldecode(file("${path.module}/../../../../environments/region.yaml")),
    yamldecode(file("${path.module}/../../../../environments/dev-webforx.yaml"))
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
    key            = "webforx/lambda/clean-up-cloudwatch-log-group/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "development-webfox-tf-state-lock"
  }
}

provider "aws" {
  region = local.env.region.dev
}

module "clean-up-cloudwatch-log-group" {
  source              = "../../../../modules/aws-lambda/clean-up-cloudwatch-log-group"
  aws_region          = local.env.region.dev
  runtime             = local.env.lambda.clean-up-cloudwatch-log-group.runtime
  timeout             = local.env.lambda.clean-up-cloudwatch-log-group.timeout
  schedule_expression = local.env.lambda.clean-up-cloudwatch-log-group.schedule_expression
  tags                = local.env.tags
}