variable "tags" {
  type        = map(string)
  description = "A map of common key-value pairs (tags) to be applied to all resources for identification and cost allocation purposes."
}

variable "aws_region" {
  type        = string
  description = "The AWS region in which to deploy the resources (e.g., us-east-1, eu-west-1)."
}

variable "eks_version" {
  type        = string
  description = "The version of the EKS (Elastic Kubernetes Service) cluster to be deployed (e.g., 1.28, 1.29)."
}

variable "endpoint_private_access" {
  type        = bool
  description = "Indicates whether the EKS cluster's API server endpoint should be accessible privately (within the VPC)."
}

variable "endpoint_public_access" {
  type        = bool
  description = "Indicates whether the EKS cluster's API server endpoint should be accessible publicly over the internet."
}

variable "public_subnets" {
  type        = map(string)
  description = ""
}
