variable "aws_region" {
  type = string
}

variable "control_plane_name" {
  type = string
  description = "The name of the Kubernetes control plane or another control plane resource."
}