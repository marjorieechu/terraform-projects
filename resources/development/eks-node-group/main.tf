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
    key            = "webfox/eks-node-group/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "development-webfox-tf-state-lock"
  }
}

provider "aws" {
  region = local.env.region.dev
}

module "eks-node-group" {
  source                    = "../../../modules/eks-node-group"
  aws_region                = local.env.region.dev
  private_subnet            = local.env.vpc.private_subnets
  eks_version               = local.env.eks.node_group.eks_version
  node_min                  = local.env.eks.node_group.node_min
  desired_node              = local.env.eks.node_group.desired_node
  node_max                  = local.env.eks.node_group.node_max
  blue_node_color           = local.env.eks.node_group.blue_node_color
  green_node_color          = local.env.eks.node_group.green_node_color
  blue                      = local.env.eks.node_group.blue
  green                     = local.env.eks.node_group.green
  ec2_ssh_key               = local.env.eks.node_group.ec2_ssh_key
  deployment_nodegroup      = local.env.eks.node_group.deployment_nodegroup
  capacity_type             = local.env.eks.node_group.capacity_type
  ami_type                  = local.env.eks.node_group.ami_type
  instance_types            = local.env.eks.node_group.instance_types
  disk_size                 = local.env.eks.node_group.disk_size
  shared_owned              = local.env.eks.node_group.shared_owned
  enable_cluster_autoscaler = local.env.eks.node_group.enable_cluster_autoscaler
  control_plane_name        = local.env.eks.node_group.control_plane_name
  tags                      = local.env.tags
}