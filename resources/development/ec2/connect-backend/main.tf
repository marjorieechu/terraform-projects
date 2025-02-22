
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
    key            = "connect/ec2/connect-backend/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "development-webfox-tf-state-lock"
  }
}

provider "aws" {
  region = local.env.region.dev
}

module "connect-backend" {
  source                        = "../../../../modules/ec2/ec2-basic"
  aws_region                    = local.env.region.dev
  ec2_instance_ami              = local.env.ec2.connect-backend.ec2_instance_ami
  ec2_instance_type             = local.env.ec2.connect-backend.ec2_instance_type
  instance_name                 = local.env.ec2.connect-backend.instance_name
  create_on_public_subnet       = local.env.ec2.connect-backend.create_on_public_subnet
  vpc_id                        = local.env.vpc.vpc_id
  private_subnet                = local.env.vpc.private_subnets
  public_subnet                 = local.env.vpc.public_subnets
  root_volume_size              = local.env.ec2.connect-backend.root_volume_size
  enable_termination_protection = local.env.ec2.connect-backend.enable_termination_protection
  ec2_instance_key_name         = local.env.ec2.connect-backend.ec2_instance_key_name
  sg_name                       = local.env.ec2.connect-backend.sg_name
  allowed_ports                 = local.env.ec2.connect-backend.allowed_ports
  tags                          = local.env.tags
}