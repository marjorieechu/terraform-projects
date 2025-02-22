variable "tags" {
  type        = map(string)
  description = "A map of common key-value pairs (tags) to be applied to all resources for identification and cost allocation purposes."
}

variable "aws_region" {
  type        = string
  description = "The AWS region in which to deploy the resources (e.g., us-east-1, eu-west-1)."
}

variable "control_plane_name" {
  type = string
}